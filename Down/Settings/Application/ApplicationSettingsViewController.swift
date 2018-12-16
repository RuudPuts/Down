//
//  ApplicationSettingsViewController.swift
//  Down
//
//  Created by Ruud Puts on 14/07/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxSwiftExt
import DownKit
import SkyFloatingLabelTextField

class ApplicationSettingsViewController: UIViewController & Depending {
    typealias Dependencies = ApplicationSettingsViewModel.Dependencies & RouterDependency & ApplicationPersistenceDependency
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

        navigationItem.titleView = UIImageView(image: AssetProvider.icons.for(application.downType))
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

    func bind(to viewModel: ApplicationSettingsViewModel) {
        let output = viewModel.transform(input: makeInput())

        [usernameTextField, passwordTextField].forEach { textField in
            output.loginResult
                .map { $0 != .authenticationRequired }
                .startWith(true)
                .asDriver(onErrorRecover: { error in
                    return Driver.just(true)
                })
                .drive(textField.rx.isHidden)
                .disposed(by: disposeBag)
        }

        output.host
            .asDriver(onErrorJustReturn: nil)
            .drive(hostTextField.rx.text)
            .disposed(by: disposeBag)

        output.apiKey
            .asDriver(onErrorJustReturn: nil)
            .drive(apiKeyTextField.rx.text)
            .disposed(by: disposeBag)

        output.isSaving
            .map { !$0 }
            .drive(saveButton.rx.isEnabled )
            .disposed(by: disposeBag)

        output.isSaving
            .map { $0 ? "Preparing cache..." : "Save" }
            .drive(saveButton.rx.title(for: .normal) )
            .disposed(by: disposeBag)

        output.settingsSaved
            .filter { $0 }
            .do(onNext: { _ in
                self.dependencies.router.restartRouter(type: self.application.type)
                self.dependencies.router.close(viewController: self)
            })
            .drive()
            .disposed(by: disposeBag)
    }

    func makeInput() -> ApplicationSettingsViewModel.Input {
        let hostDriver = hostTextField.rx.debouncedText
        let usernameDriver = usernameTextField.rx.debouncedText
        let passwordDriver = passwordTextField.rx.debouncedText
        let apiKeyDriver = apiKeyTextField.rx.debouncedText
        let saveButtonTap = saveButton.rx.tap

        return ApplicationSettingsViewModel.Input(host: hostDriver,
                                                  username: usernameDriver,
                                                  password: passwordDriver,
                                                  apiKey: apiKeyDriver,
                                                  saveButtonTapped: saveButtonTap)
    }
}
