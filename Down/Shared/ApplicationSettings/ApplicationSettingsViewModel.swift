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

        return interactorFactory
            .makeLoginInteractor(for: application, credentials: credentials)
            .observe()
            .do(onNext: { result in
                    NSLog("Login result: \(result)")
                    switch result {
                    case .success:
                        self.fetchApiKey()
                            .subscribe()
                            .disposed(by: self.disposeBag)
                        break
                    case .authenticationRequired:
                        let authenticationRequired = self.apiKey.value != nil
                        self.authenticationRequired.accept(authenticationRequired)
                    default:
                        break
                    }
                },
                onError: { error in
                    NSLog("Login error: \(error)")
                    self.authenticationRequired.accept(false)
                })
    }

    func fetchApiKey() -> Observable<String?> {
        return interactorFactory
            .makeApiKeyInteractor(for: application)
            .observe()
            .do(onNext: {
                    if let apiKey = $0 {
                        NSLog("Api key: \(apiKey)")
                        self.apiKey.accept(apiKey)
                        self.authenticationRequired.accept(true)
                    }
                    else {
                        NSLog("⚠️ Api key fetch was succesful, but no data was returend!")
                    }
                },
                 onError: { error in
                    NSLog("ApiKey error: \(error)")
                })
    }
}
