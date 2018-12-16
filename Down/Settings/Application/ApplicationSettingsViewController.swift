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
import Result

class ApplicationSettingsViewController: UIViewController & Depending {
    typealias Dependencies = ApplicationSettingsViewModel.Dependencies
        & RouterDependency
        & ApplicationPersistenceDependency
        & ErrorHandlerDependency
    let dependencies: Dependencies

    let application: ApiApplication
    var disposeBag: DisposeBag! = DisposeBag()

    lazy var viewModel = ApplicationSettingsViewModel(dependencies: dependencies, application: application)

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

        applyStyling()
        configureTextFields()
        bind(to: viewModel)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        disposeBag = nil
    }

    func applyStyling() {
        view.style(as: .backgroundView)

        saveButton.style(as: .successButton)

        [hostTextField, usernameTextField, passwordTextField, apiKeyTextField].forEach {
            $0?.style(as: .floatingLabelTextField(for: application.downType))
        }

        navigationItem.titleView = UIImageView(image: AssetProvider.Icon.for(application.downType))
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

    func makeInput() -> ApplicationSettingsViewModel.Input {
        let hostDriver = hostTextField.rx.debouncedText
        let usernameDriver = usernameTextField.rx.debouncedText
        let passwordDriver = passwordTextField.rx.debouncedText
        let apiKeyDriver = apiKeyTextField.rx.debouncedText
        let saveButtonTap = saveButton.rx.tap

        return ApplicationSettingsViewModel.Input(
            host: hostDriver,
            username: usernameDriver,
            password: passwordDriver,
            apiKey: apiKeyDriver,
            saveButtonTapped: saveButtonTap
        )
    }

    func bind(to viewModel: ApplicationSettingsViewModel) {
        let output = viewModel.transform(input: makeInput())

        let authenticationRequired = output.loginResult
            .map { $0 != .authenticationRequired }
        bindTextFields(host: output.host, apiKey: output.apiKey,
                       authenticationRequired: authenticationRequired)

        bindIsSaving(output.isSaving)
        bindSettingsSaved(output.settingsSaved)
    }

    private func bindTextFields(host: Driver<String?>, apiKey: Driver<String?>, authenticationRequired: Driver<Bool>) {
        host.drive(hostTextField.rx.text)
            .disposed(by: disposeBag)

        apiKey.drive(apiKeyTextField.rx.text)
            .disposed(by: disposeBag)

        [usernameTextField, passwordTextField].forEach { textField in
            authenticationRequired
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
}
