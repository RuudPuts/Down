//
//  ApplicationSettingsViewModel.swift
//  Down
//
//  Created by Ruud Puts on 14/07/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import DownKit
import RxSwift

class ApplicationSettingsViewModel {
    private var application: ApiApplication
    private var interactorFactory: ApiApplicationInteractorProducing

    // Make these observable
    var host: String?
    var username: String?
    var password: String?
    var apiKey: String?

    init(application: ApiApplication,
         interactorFactory: ApiApplicationInteractorProducing) {
        self.application = application
        self.interactorFactory = interactorFactory

        self.host = application.host
        self.apiKey = application.apiKey
    }

    func login(host: String, credentials: UsernamePassword? = nil) -> Observable<LoginResult> {
        self.host = host
        self.username = credentials?.username
        self.password = credentials?.password

        return interactorFactory
            .makeLoginInteractor(for: application, credentials: credentials)
            .observe()
    }

    func fetchApiKey() -> Observable<String?> {
        return interactorFactory
            .makeApiKeyInteractor(for: application)
            .observe()
            .do(onNext: {
                if let apiKey = $0 {
                    self.apiKey = apiKey
                }
            })
    }
}
