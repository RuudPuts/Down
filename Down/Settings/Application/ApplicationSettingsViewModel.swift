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
        let loginResult: Observable<LoginResult>
        let host: Observable<String?>
        let apiKey: Observable<String?>

        let isSaving: Observable<Bool>
        let settingsSaved: Observable<Bool>
    }

    func transform(input: Input) -> Output {
        let observableApplication = input.host
            .map { host -> ApiApplication in
                var application = self.application.copy() as! ApiApplication
                application.host = host

                return application
            }

        let credentialsDriver = Observable.zip([input.username, input.password])
            .map { input -> UsernamePassword? in
                guard let username = input.first, username.count > 0,
                      let password = input.last, password.count > 0 else {
                    return nil
                }

                return (username: username, password: password)
            }


        let hostChangedObservable = observableApplication
            .withLatestFrom(credentialsDriver) { application, credentials in
                return (application: application, credentials: credentials)
            }

        let credentialsChangedObservable = credentialsDriver
            .withLatestFrom(observableApplication) { credentials, application in
                return (application: application, credentials: credentials)
            }

        let loginObservable = Observable<LoginInputTuple>.merge([hostChangedObservable, credentialsChangedObservable])
            .asObservable()
            .flatMap {
                self.login(for: $0.application, withCredentials: $0.credentials)
            }

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
            .startWith(application.apiKey)

        let isSavingSubject = BehaviorSubject(value: false)
        let latestApiKey = Observable.merge(apiKeyObservable.unwrap(), input.apiKey)

        let settingsSavedDriver = input.saveButtonTapped
            .withLatestFrom(observableApplication)
            .withLatestFrom(latestApiKey) { application, apiKey in
                var application = application
                application.apiKey = apiKey

                return application
            }
            .do(onNext: {
                isSavingSubject.onNext(true)
                self.dependencies.persistence.store($0)
            })
            .flatMap { self.updateCache(for: $0) }
            .do(onNext: { _ in
                isSavingSubject.onNext(false)
            })

        return Output(loginResult: loginObservable,
                      host: Observable.just(application.host),
                      apiKey: apiKeyObservable,
                      isSaving: isSavingSubject.asObservable(),
                      settingsSaved: settingsSavedDriver)
    }

    func login(for application: ApiApplication, withCredentials credentials: UsernamePassword?) -> Single<LoginResult> {
        return dependencies.apiInteractorFactory
            .makeLoginInteractor(for: application, credentials: credentials)
            .observeResult()
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
            .observeResult()
            .do(
                onSuccess: {
                    guard let apiKey = $0 else {
                        NSLog("⚠️ Api key fetch was succesful, but no data was returend!")
                        return
                    }

                    NSLog("Api key: \(apiKey)")
                },
                onFailure: { error in
                    NSLog("ApiKey error: \(error)")
                }
            )
            .map { $0.value ?? nil }
            .asSingle()
    }

    func updateCache(for application: ApiApplication) -> Single<Bool> {
        guard let dvrApplication = application as? DvrApplication else {
            return Single.just(true)
        }

        return dependencies.dvrInteractorFactory
            .makeShowCacheRefreshInteractor(for: dvrApplication)
            .observeResult()
            .do(
                onSuccess: { shows in
                    NSLog("Cache updated")
                },
                onFailure: { error in
                    NSLog("Cache error: \(error)")
                }
            )
            .asSingle()
            .map { $0.error == nil }
    }
}
