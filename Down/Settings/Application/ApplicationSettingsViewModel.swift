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
        let host: Driver<String>
        let username: Driver<String>
        let password: Driver<String>
        let apiKey: Driver<String>

        let saveButtonTapped: ControlEvent<Void>
    }

    struct Output {
        let loginResult: Driver<LoginResult>
        let host: Driver<String?>
        let apiKey: Driver<String?>

        let isSaving: Driver<Bool>
        let settingsSaved: Driver<Bool>
    }

    func transform(input: Input) -> Output {
        let observableApplication = input.host
            .map { host -> ApiApplication in
                var application = self.application.copy() as! ApiApplication
                application.host = host

                return application
            }

        let usernameChanged = input.username.withLatestFrom(input.password) { (username: $0, password: $1) }
        let passwordChanged = input.password.withLatestFrom(input.username) { (username: $1, password: $0) }

        let credentialsDriver = Driver.merge([usernameChanged, passwordChanged])
            .map { input -> UsernamePassword? in
                guard !input.username.isEmpty, !input.password.isEmpty else {
                    return nil
                }

                return (username: input.username, password: input.password)
            }
            .asDriver(onErrorJustReturn: nil)

        let hostChangedObservable = observableApplication
            .withLatestFrom(credentialsDriver) { application, credentials in
                return (application: application, credentials: credentials)
            }

        let credentialsChangedObservable = credentialsDriver
            .withLatestFrom(observableApplication) { credentials, application in
                return (application: application, credentials: credentials)
            }

        let loginObservable = Driver.merge([hostChangedObservable, credentialsChangedObservable])
            .asObservable()
            .flatMapLatest {
                self.login(for: $0.application, withCredentials: $0.credentials)
            }
            .asDriver(onErrorJustReturn: .failed)

        let apiKeyObservable = loginObservable
            .filter { $0 == .success }
            .withLatestFrom(credentialsDriver) { _, credentials in
                return (application: self.application, credentials: credentials)
            }
            .withLatestFrom(observableApplication) { input, application in
                return (application: application, credentials: input.credentials)
            }
            .asObservable()
            .flatMapLatest {
                self.fetchApiKey(for: $0.application, withCredentials: $0.credentials)
            }
            .startWith(application.apiKey)
            .asDriver(onErrorJustReturn: nil)

        let isSavingSubject = BehaviorSubject(value: false)
        let latestApiKey = Observable.merge(
                apiKeyObservable.asObservable().unwrap(),
                input.apiKey.asObservable()
            )
            .asDriver(onErrorJustReturn: "")

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
            .asDriver(onErrorJustReturn: false)
            .do(onNext: { _ in
                isSavingSubject.onNext(false)
            })

        return Output(loginResult: loginObservable,
                      host: Driver.just(application.host),
                      apiKey: apiKeyObservable,
                      isSaving: isSavingSubject.asDriver(onErrorJustReturn: false),
                      settingsSaved: settingsSavedDriver)
    }

    func login(for application: ApiApplication, withCredentials credentials: UsernamePassword?) -> Single<LoginResult> {
        return dependencies.apiInteractorFactory
            .makeLoginInteractor(for: application, credentials: credentials)
            .observeResult()
            .do(
                onSuccess: { result in
                    NSLog("Login result -> \(result)")
                },
                onFailure: { error in
                    NSLog("Login error -> \(error)")
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
                        NSLog("⚠️ -> Api key fetch was succesful, but no data was returend!")
                        return
                    }

                    NSLog("Api key -> \(apiKey)")
                },
                onFailure: { error in
                    NSLog("ApiKey error -> \(error)")
                }
            )
            .map { $0.value ?? nil }
            .asSingle()
    }

    //! show error to user if any
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
