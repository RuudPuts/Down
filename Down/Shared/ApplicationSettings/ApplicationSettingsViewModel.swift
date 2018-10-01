//
//  ApplicationSettingsViewModel.swift
//  Down
//
//  Created by Ruud Puts on 14/07/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import DownKit
import RxSwift
import RxCocoa

class ApplicationSettingsViewModel {
    var host = BehaviorRelay<String?>(value: nil)
    var username = BehaviorRelay<String?>(value: nil)
    var password = BehaviorRelay<String?>(value: nil)
    var apiKey = BehaviorRelay<String?>(value: nil)

    var authenticationRequired = BehaviorRelay<Bool>(value: false)

    private var application: ApiApplication
    private var interactorFactory: ApiApplicationInteractorProducing
    private let disposeBag = DisposeBag()

    init(application: ApiApplication,
         interactorFactory: ApiApplicationInteractorProducing) {
        self.application = application
        self.interactorFactory = interactorFactory

        host.accept(application.host)
        apiKey.accept(application.apiKey)
    }

    func login(host: String, credentials: UsernamePassword? = nil) -> Observable<LoginResult> {
        self.host.accept(host)
        self.username.accept(credentials?.username)
        self.password.accept(credentials?.password)

        var applicationCopy = application.copy() as! ApiApplication
        applicationCopy.host = host

        return interactorFactory
            .makeLoginInteractor(for: applicationCopy, credentials: credentials)
            .observe()
            .do(onNext: { result in
                    NSLog("Login result: \(result)")
                    switch result {
                    case .success:
                        self.host.accept(host)
                        self.fetchApiKey(credentials: credentials)
                            .subscribe()
                            .disposed(by: self.disposeBag)
                        break
                    case .authenticationRequired:
                        let authenticationRequired = self.apiKey.value == nil
                        self.authenticationRequired.accept(authenticationRequired)
                        break
                    default: break
                    }
                },
                onError: { error in
                    NSLog("Login error: \(error)")
                    self.authenticationRequired.accept(false)
                })
    }

    func fetchApiKey(credentials: UsernamePassword? = nil) -> Observable<String?> {
        var applicationCopy = application.copy() as! ApiApplication
        applicationCopy.host = host.value!

        return interactorFactory
            .makeApiKeyInteractor(for: applicationCopy, credentials: credentials)
            .observe()
            .do(onNext: {
                    guard let apiKey = $0 else {
                        NSLog("⚠️ Api key fetch was succesful, but no data was returend!")
                        return
                    }

                    NSLog("Api key: \(apiKey)")
                    self.apiKey.accept(apiKey)
                    self.authenticationRequired.accept(false)
                },
                 onError: { error in
                    NSLog("ApiKey error: \(error)")
                })
    }

    func save() {
        guard let host = self.host.value, let apiKey = self.apiKey.value else {
            return
        }

        application.host = host
        application.apiKey = apiKey
        UserDefaults.standard.store(application)
    }
}
