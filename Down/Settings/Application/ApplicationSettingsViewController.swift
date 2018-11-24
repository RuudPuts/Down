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
    let disposeBag = DisposeBag()

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

    func applyStyling() {
        view.style(as: .backgroundView)

        saveButton.style(as: .successButton)

        [hostTextField, usernameTextField, passwordTextField, apiKeyTextField].forEach {
            $0?.style(as: .textField(for: application.downType))
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
                .debug("LoginResult")
                .drive(textField.rx.isHidden)
                .disposed(by: disposeBag)
        }

        output.apiKey
            .asDriver(onErrorJustReturn: nil)
            .drive(apiKeyTextField.rx.text)
            .disposed(by: disposeBag)

//        sender.isEnabled = isSaving
//        sender.setTitle(isSaving ? "Preparing cache..." : "Save", for: .normal)

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
        let hostDriver = hostTextField.rx.textDriver
        let usernameDriver = usernameTextField.rx.textDriver
        let passwordDriver = passwordTextField.rx.textDriver
        let apiKeyDriver = apiKeyTextField.rx.textDriver
        let saveButtonTap = saveButton.rx.tap

        return ApplicationSettingsViewModel.Input(host: hostDriver,
                                                  username: usernameDriver,
                                                  password: passwordDriver,
                                                  apiKey: apiKeyDriver,
                                                  saveButtonTapped: saveButtonTap)
    }
}
