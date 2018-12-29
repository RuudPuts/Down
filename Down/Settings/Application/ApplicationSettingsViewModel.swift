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
import Result
import RxResult

struct ApplicationSettingsViewModel: Depending {
    typealias Dependencies = ApiApplicationInteractorFactoryDependency & DvrInteractorFactoryDependency & ApplicationPersistenceDependency
    let dependencies: Dependencies

    var input = Input()
    lazy var output = transform(input: input)

    private var application: ApiApplication

    init(dependencies: Dependencies, application: ApiApplication) {
        self.dependencies = dependencies
        self.application = application
    }
}

extension ApplicationSettingsViewModel: ReactiveBindable {
    private typealias LoginInputTuple = (application: ApiApplication, credentials: UsernamePassword?)

    struct Input {
        let host = PublishSubject<String>()
        let username = PublishSubject<String>()
        let password = PublishSubject<String>()
        let apiKey = PublishSubject<String>()

        let saveButtonTapped = PublishSubject<Void>()
    }

    struct Output {
        let loginResult: Driver<LoginResult>
        let host: Driver<String?>
        let apiKey: Driver<String?>

        let isSaving: Driver<Bool>
        let settingsSaved: Driver<Result<Void, DownError>>
    }
}

extension ApplicationSettingsViewModel {
    func transform(input: Input) -> Output {
        let observableApplication = transformApplication(input.host.asDriver(onErrorJustReturn: String()))
        let credentials = transformCredentials(username: input.username.asDriver(onErrorJustReturn: String()),
                                               password: input.password.asDriver(onErrorJustReturn: String()))

        let loginResult = transformLogin(application: observableApplication, credentials: credentials)

        let fetchedApiKey = transformFetchApiKey(
                from: loginResult,
                application: observableApplication,
                credentials: credentials
            )
            .startWith(application.apiKey)

        let latestApiKey = Observable.merge(
                fetchedApiKey.asObservable().unwrap(),
                input.apiKey.asObservable()
            )
            .asDriver(onErrorJustReturn: "")

        let transformedSave = transformSaveSettings(from: input.saveButtonTapped,
                                                    application: observableApplication,
                                                    apiKey: latestApiKey)

        return Output(loginResult: loginResult,
                      host: Driver.just(application.host),
                      apiKey: fetchedApiKey,
                      isSaving: transformedSave.isSaving,
                      settingsSaved: transformedSave.settingsSaved)
    }

    private func transformApplication(_ host: Driver<String>) -> Driver<ApiApplication> {
        return host
            .map { host -> ApiApplication in
                // swiftlint:disable:next force_cast
                var application = self.application.copy() as! ApiApplication
                application.host = host

                return application
            }
    }

    private func transformCredentials(username: Driver<String>, password: Driver<String>) -> Driver<UsernamePassword?> {
        let usernameChanged = username.withLatestFrom(password) { (username: $0, password: $1) }
        let passwordChanged = password.withLatestFrom(username) { (username: $1, password: $0) }

        return Driver.merge([usernameChanged, passwordChanged])
            .map { input -> UsernamePassword? in
                guard !input.username.isEmpty, !input.password.isEmpty else {
                    return nil
                }

                return (username: input.username, password: input.password)
            }
            .asDriver(onErrorJustReturn: nil)
    }

    private func transformLogin(application: Driver<ApiApplication>, credentials: Driver<UsernamePassword?>) -> Driver<LoginResult> {
        let hostChangedObservable = application
            .withLatestFrom(credentials) { application, credentials in
                return (application: application, credentials: credentials)
        }

        let credentialsChangedObservable = credentials
            .withLatestFrom(application) { credentials, application in
                return (application: application, credentials: credentials)
        }

        return Driver.merge([hostChangedObservable, credentialsChangedObservable])
            .asObservable()
            .flatMapLatest {
                self.login(for: $0.application, withCredentials: $0.credentials)
            }
            .asDriver(onErrorJustReturn: .failed)
    }

    private func login(for application: ApiApplication, withCredentials credentials: UsernamePassword?) -> Single<LoginResult> {
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

    private func transformFetchApiKey(from loginResult: Driver<LoginResult>, application: Driver<ApiApplication>, credentials: Driver<UsernamePassword?>) -> Driver<String?> {
        return loginResult
            .filter { $0 == .success }
            .withLatestFrom(credentials) { _, credentials in
                return (application: self.application, credentials: credentials)
            }
            .withLatestFrom(application) { input, application in
                return (application: application, credentials: input.credentials)
            }
            .asObservable()
            .flatMapLatest {
                self.fetchApiKey(for: $0.application, withCredentials: $0.credentials)
            }
            .asDriver(onErrorJustReturn: nil)
    }

    private func fetchApiKey(for application: ApiApplication, withCredentials credentials: UsernamePassword?) -> Single<String?> {
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

    private func transformSaveSettings(from input: Observable<Void>, application: Driver<ApiApplication>, apiKey: Driver<String>) -> (isSaving: Driver<Bool>, settingsSaved: Driver<Result<Void, DownError>>) {
        let isSavingSubject = BehaviorSubject(value: false)

        let settingsSaved = input
            .withLatestFrom(application)
            .withLatestFrom(apiKey) { application, apiKey in
                var application = application
                application.apiKey = apiKey

                return application
            }
            .do(onNext: {
                isSavingSubject.onNext(true)
                self.dependencies.persistence.store($0)
            })
            .flatMap { self.updateCache(for: $0) }
            .asDriver(onErrorJustReturn: .success(Void()))
            .do(onNext: { _ in
                isSavingSubject.onNext(false)
            })

        return (
            isSaving: isSavingSubject.asDriver(onErrorJustReturn: false),
            settingsSaved: settingsSaved
        )
    }

    private func updateCache(for application: ApiApplication) -> Single<Result<Void, DownError>> {
        guard let dvrApplication = application as? DvrApplication else {
            return Single.just(.success(Void()))
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
            .map { $0.map { _ in } }
            .asSingle()
    }
}
