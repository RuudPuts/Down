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

class ApplicationSettingsViewController: UIViewController & Routing & ApiApplicationInteracting {
    var application: ApiApplication!
    var interactorFactory: ApiApplicationInteractorProducing!
    var router: Router?
    let disposeBag = DisposeBag()

    lazy var viewModel = ApplicationSettingsViewModel(application: application,
                                                      interactorFactory: interactorFactory)

    @IBOutlet weak var hostTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var usernameTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var passwordTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var apiKeyTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var headerView: ApplicationHeaderView!

    override func viewDidLoad() {
        super.viewDidLoad()

//        Driver.just(application).drive
        headerView.application = application as? DownApplication
        
        headerView.button?.setImage(AssetProvider.icons.close, for: .normal)
        headerView.button?.rx.tap
            .subscribe(onNext: { _ in
                self.router?.close(viewController: self)
            })
            .disposed(by: disposeBag)

        hostTextField.text = application.host
        apiKeyTextField.text = application.apiKey

        [hostTextField, usernameTextField, passwordTextField].forEach {
            $0.rx.text
                .skip(2)
                .debounce(0.3, scheduler: MainScheduler.instance)
                .subscribe(onNext: { _ in
                    self.performLogin()
                })
                .disposed(by: disposeBag)
        }
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
            .subscribe(
                onNext: { result in
                    NSLog("Login result: \(result)")
                },
                onError: { error in
                    NSLog("Login error: \(error)")
                })
            .disposed(by: disposeBag)
    }
}
