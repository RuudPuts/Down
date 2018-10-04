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

class ApplicationSettingsViewController: UIViewController & Routing & ApiApplicationInteracting, DvrApplicationInteracting {
    var apiApplication: ApiApplication!
    var apiInteractorFactory: ApiApplicationInteractorProducing!
    var dvrApplication: DvrApplication!
    var dvrInteractorFactory: DvrInteractorProducing!

    var router: Router?
//    var settingsChangeActions: [ApplicationSettingsChangedAction]?
    let disposeBag = DisposeBag()

    lazy var viewModel = ApplicationSettingsViewModel(application: apiApplication,
                                                      apiInteractorFactory: apiInteractorFactory,
                                                      dvrInteractorFactory: dvrInteractorFactory)

    @IBOutlet weak var hostTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var usernameTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var passwordTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var apiKeyTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var saveButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        applyStyling()
        configureTextFields()
    }

    func applyStyling() {
        view.style(as: .backgroundView)

        saveButton.style(as: .successButton)

        [hostTextField, usernameTextField, passwordTextField, apiKeyTextField].forEach {
            $0?.style(as: .textField(for: apiApplication.downType))
        }

        navigationItem.titleView = UIImageView(image: AssetProvider.icons.for(apiApplication.downType))
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
        viewModel.save()
        router?.store(application: self.apiApplication)

        viewModel.updateApplicationCache()
            .subscribe(onCompleted: { [weak self] in
                guard let `self` = self else { return }

                self.router?.restartRouter(type: self.apiApplication.type)
                self.router?.close(viewController: self)
            })
            .disposed(by: disposeBag)
    }

    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        router?.close(viewController: self)
    }
}
