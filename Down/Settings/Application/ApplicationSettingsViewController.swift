//
//  ApplicationSettingsViewController.swift
//  Down
//
//  Created by Ruud Puts on 14/07/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

import DownKit
import RxSwift
import RxCocoa
import RxSwiftExt
import RxRealm

class ApplicationSettingsViewController: UIViewController & Depending {
    typealias Dependencies = ApplicationSettingsViewModel.Dependencies
        & RouterDependency
        & ApplicationPersistenceDependency
        & ErrorHandlerDependency
    let dependencies: Dependencies

    let application: ApiApplication
    var disposeBag: DisposeBag!

    lazy var viewModel = ApplicationSettingsViewModel(dependencies: dependencies, application: application)

    @IBOutlet weak var headerView: ApplicationHeaderView!
    @IBOutlet weak var hostTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var usernameTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var passwordTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var apiKeyTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var saveButton: UIButton!

    init(dependencies: Dependencies, application: ApiApplication) {
        self.dependencies = dependencies
        self.application = application

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureContextButton()
        configureTextFields()
        applyStyling()

        disposeBag = DisposeBag()
        bind(to: viewModel)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        disposeBag = nil
    }

    private func configureContextButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem.contextButton(target: self, action: #selector(showContextMenu))
    }

    func applyStyling() {
        let applicationType = application.downType

        edgesForExtendedLayout = .top
        
        view.style(as: .backgroundView)
        navigationItem.rightBarButtonItem?.style(as: .barButtonItem(applicationType))

        headerView.style(as: .headerView(for: applicationType))
        headerView.contextButton.isHidden = true

        [hostTextField, usernameTextField, passwordTextField, apiKeyTextField].forEach {
            $0?.style(as: .floatingLabelTextField(for: applicationType))
        }

        saveButton.style(as: .successButton)
    }

    func configureTextFields() {
        [hostTextField, usernameTextField, passwordTextField, apiKeyTextField].forEach { textField in
            textField?.delegate = self
        }
    }

    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        dependencies.router.close(viewController: self)
    }
}

@objc extension ApplicationSettingsViewController {
    func showContextMenu() {
        let actionController = DownActionController(applicationType: dependencies.dvrApplication.downType)

        actionController.addAction(title: "Clear settings", style: .destructive, handler: { _ in
            self.viewModel.input.clearSettings.onNext(Void())
        })

        actionController.addCancelSection()

        present(actionController, animated: true, completion: nil)
    }
}

extension ApplicationSettingsViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let illegalCharacterSet = CharacterSet.whitespacesAndNewlines
        
        if string.rangeOfCharacter(from: illegalCharacterSet) != nil,
            let replaceStart = textField.position(from: textField.beginningOfDocument, offset: range.location),
            let replaceEnd = textField.position(from: replaceStart, offset: range.length),
            let textRange = textField.textRange(from: replaceStart, to: replaceEnd) {
            
            // replace current content with stripped content
            let strippedString = string.components(separatedBy: illegalCharacterSet).joined()
            textField.replace(textRange, withText: strippedString)
            return false
        }
        return true
    }
}

extension ApplicationSettingsViewController: ReactiveBinding {
    typealias Bindable = ApplicationSettingsViewModel

    func bind(input: ApplicationSettingsViewModel.Input) {
        hostTextField.rx.debouncedText
            .drive(input.host)
            .disposed(by: disposeBag)

        usernameTextField.rx.debouncedText
            .drive(input.username)
            .disposed(by: disposeBag)

        passwordTextField.rx.debouncedText
            .drive(input.password)
            .disposed(by: disposeBag)

        apiKeyTextField.rx.debouncedText
            .drive(input.apiKey)
            .disposed(by: disposeBag)

        saveButton.rx.tap
            .bind(to: input.saveSettings)
            .disposed(by: disposeBag)
    }

    func bind(output: ApplicationSettingsViewModel.Output) {
        let authenticationRequired = output.loginResult
            .map { $0 != .authenticationRequired }

        let apiKeySet = output.loginResult
            .filter { $0 == .authenticationRequired }
            .withLatestFrom(output.apiKey)
            .map { !($0?.isEmpty ?? true) }

        let credentialsFieldsVisible = Driver.merge([authenticationRequired, apiKeySet])

        bindTextFields(host: output.host,
                       apiKey: output.apiKey,
                       credentialsFieldsVisisble: credentialsFieldsVisible)

        bindIsSaving(output.isSaving)
        bindSettingsSaved(output.settingsSaved)
        bindSettingsCleared(output.settingsCleared)
    }

    private func bindTextFields(host: Driver<String?>, apiKey: Driver<String?>, credentialsFieldsVisisble: Driver<Bool>) {
        host.drive(hostTextField.rx.text)
            .disposed(by: disposeBag)

        apiKey.drive(apiKeyTextField.rx.text)
            .disposed(by: disposeBag)

        [usernameTextField, passwordTextField].forEach { textField in
            credentialsFieldsVisisble
                .startWith(true)
                .drive(textField.rx.isHidden)
                .disposed(by: disposeBag)
        }
    }

    private func bindIsSaving(_ isSaving: Driver<Bool>) {
        isSaving
            .map { !$0 }
            .drive(saveButton.rx.isEnabled )
            .disposed(by: disposeBag)

        isSaving
            .map { $0 ? "Preparing cache..." : "Save" }
            .drive(saveButton.rx.title(for: .normal) )
            .disposed(by: disposeBag)
    }

    private func bindSettingsSaved(_ settingsSaved: Driver<Result<Void, DownError>>) {
        settingsSaved
            .asObservable()
            .do(
                onSuccess: {
                    self.dependencies.router.restartRouter(type: self.application.type)
                    self.dependencies.router.close(viewController: self)
                },
                onFailure: {
                    self.dependencies.errorHandler.handle(error: $0,
                                                          action: .settings_updateCache,
                                                          source: self)
                }
            )
            .subscribe()
            .disposed(by: disposeBag)
    }

    private func bindSettingsCleared(_ settingsCleared: Observable<Void>) {
        settingsCleared
            .subscribe(onNext: {
                self.dependencies.router.restartRouter(type: self.application.type)
                self.dependencies.router.close(viewController: self)
            })
            .disposed(by: disposeBag)
    }
}
