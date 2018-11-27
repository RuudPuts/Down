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
import RxResult

struct ApplicationSettingsViewModel: Depending {
    typealias Dependencies = ApiApplicationInteractorFactoryDependency & DvrInteractorFactoryDependency & ApplicationPersistenceDependency
    let dependencies: Dependencies

    private var application: ApiApplication

    init(dependencies: Dependencies, application: ApiApplication) {
        self.dependencies = dependencies
        self.application = application
    }
}

extension ApplicationSettingsViewModel: ReactiveBindable {
    private typealias LoginInputTuple = (application: ApiApplication, credentials: UsernamePassword?)

    struct Input {
        let host: Observable<String>
        let username: Observable<String>
        let password: Observable<String>
        let apiKey: Observable<String>

        let saveButtonTapped: ControlEvent<Void>
    }

    struct Output {
        let loginResult: Driver<LoginResult>
        let apiKey: Driver<String?>

        let settingsSaved: Driver<Bool>
    }

    func transform(input: Input) -> Output {
        // wil this work? host might not be set without api key
//        let observableApplication = Driver.zip([input.host, input.apiKey])
//            .map { input -> ApiApplication in
//                var application = self.application.copy() as! ApiApplication
//
//                application.host = input.first ?? ""
//                application.apiKey = input.last ?? ""
//
//                return application
//            }

        let observableApplication = input.host
            .map { host -> ApiApplication in
                var application = self.application.copy() as! ApiApplication
                application.host = host

                return application
            }
            .debug("Application")

        let credentialsDriver = Observable.zip([input.username, input.password])
            .map { input -> UsernamePassword? in
                guard let username = input.first, username.count > 0,
                      let password = input.last, password.count > 0 else {
                    return nil
                }

                return (username: username, password: password)
            }


        let hostChangedLoginDriver = observableApplication
            .withLatestFrom(credentialsDriver) { application, credentials in
                return (application: application, credentials: credentials)
            }
            .debug("HostChanged")

        let credentialsChangedLoginDriver = credentialsDriver
            .withLatestFrom(observableApplication) { credentials, application in
                return (application: application, credentials: credentials)
            }

        let loginObservable = Observable<LoginInputTuple>.merge([hostChangedLoginDriver, credentialsChangedLoginDriver])
            .asObservable()
            .flatMap {
                self.login(for: $0.application, withCredentials: $0.credentials)
            }
            .debug("Login")

        let apiKeyObservable = loginObservable
            .filter { $0 == .success }
            .withLatestFrom(credentialsDriver) { _, credentials in
                return (application: self.application, credentials: credentials)
            }
            .withLatestFrom(observableApplication) { input, application in
                return (application: application, credentials: input.credentials)
            }
            .flatMap {
                self.fetchApiKey(for: $0.application, withCredentials: $0.credentials)
            }

        let applicationSavedDriver = input.saveButtonTapped
            .withLatestFrom(observableApplication) { _, application in
                return application
            }
            .do(onNext: {
                self.dependencies.persistence.store($0)
            })

        let settingsSavedDriver = applicationSavedDriver
            .flatMap { self.updateCache(for: $0)}
            .asDriver(onErrorJustReturn: true)

        return Output(loginResult: loginObservable.asDriver(onErrorJustReturn: .failed),
                      apiKey: apiKeyObservable.asDriver(onErrorJustReturn: nil),
                      settingsSaved: settingsSavedDriver)
    }

    func login(for application: ApiApplication, withCredentials credentials: UsernamePassword?) -> Single<LoginResult> {
        return dependencies.apiInteractorFactory
            .makeLoginInteractor(for: application, credentials: credentials)
            .observe()
            .asObservable()
            .do(
                onSuccess: { result in
                    NSLog("Login result: \(result)")
                },
                onFailure: { error in
                    NSLog("Login error: \(error)")
                }
            )
            .map { $0.value ?? .failed }
            .asSingle()
    }

    func fetchApiKey(for application: ApiApplication, withCredentials credentials: UsernamePassword?) -> Single<String?> {
        return dependencies.apiInteractorFactory
            .makeApiKeyInteractor(for: application, credentials: credentials)
            .observe()
            .map { $0.value! }
            .do(onSuccess: {
                guard let apiKey = $0 else {
                    NSLog("⚠️ Api key fetch was succesful, but no data was returend!")
                    return
                }

                NSLog("Api key: \(apiKey)")
            },
            onError: { error in
                NSLog("ApiKey error: \(error)")
            })
    }

    func updateCache(for application: ApiApplication) -> Single<Bool> {
        guard let dvrApplication = application as? DvrApplication else {
            return Single.just(true)
        }

        return dependencies.dvrInteractorFactory
            .makeShowCacheRefreshInteractor(for: dvrApplication)
            .observe()
            .map { _ in true }
    }
}
