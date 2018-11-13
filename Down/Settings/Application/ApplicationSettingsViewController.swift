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
        let hideFieldsDriver = viewModel.authenticationRequired
            .asDriver()
            .map { !$0 }

        hideFieldsDriver
            .drive(usernameTextField.rx.isHidden)
            .disposed(by: disposeBag)

        hideFieldsDriver
            .drive(passwordTextField.rx.isHidden)
            .disposed(by: disposeBag)

        viewModel.host.asDriver()
            .drive(hostTextField.rx.text)
            .disposed(by: disposeBag)

        viewModel.apiKey.asDriver()
            .drive(apiKeyTextField.rx.text)
            .disposed(by: disposeBag)

        [hostTextField, usernameTextField, passwordTextField].forEach {
            $0.rx.text
                .skip(2)
                .debounce(0.3, scheduler: MainScheduler.instance)
                .subscribe(onNext: { [weak self] _ in
                    guard let `self` = self else { return }
                    
                    // Text needs to be subscribed to the view model as well..
                    // Should the text directly bind to the view model's variables?
                    // And make it do the perform login below?
                    self.performLogin()
                })
                .disposed(by: disposeBag)
        }

        apiKeyTextField.rx.text
            .skip(2)
            .debounce(0.3, scheduler: MainScheduler.instance)
            .subscribe(onNext: {
                self.viewModel.apiKey.accept($0)
            })
            .disposed(by: disposeBag)
    }

    func performLogin() {
        guard let host = hostTextField.text, host.count > 0 else {
            return
        }

        var credentials: UsernamePassword?
        if let username = usernameTextField.text, username.count > 0,
           let password = passwordTextField.text, password.count > 0 {
            credentials = (username: username, password: password)
        }

        viewModel.login(host: host, credentials: credentials)
            .subscribe()
            .disposed(by: disposeBag)
    }

    func fetchApiKey() {
        viewModel.fetchApiKey()
            .subscribe()
            .disposed(by: disposeBag)
    }

    @IBAction func saveButtonTapped(_ sender: UIButton) {
        sender.isEnabled = false
        sender.setTitle("Preparing cache...", for: .normal)
        
        viewModel.save()
        dependencies.persistence.store(self.application)

        viewModel.updateApplicationCache()
            .subscribe(onCompleted: { [weak self] in
                guard let `self` = self else { return }

                self.dependencies.router.restartRouter(type: self.application.type)
                self.dependencies.router.close(viewController: self)
            })
            .disposed(by: disposeBag)
    }

    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        dependencies.router.close(viewController: self)
    }
}
