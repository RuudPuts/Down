//
//  ApiApplicationLoginGateway.swift
//  DownKit
//
//  Created by Ruud Puts on 26/06/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import RxSwift

public class ApiApplicationLoginGateway: ApiApplicationRequestGateway {
    var builder: ApiApplicationRequestBuilding
    var executor: RequestExecuting
    var parser: ApiApplicationResponseParsing
    var credentials: UsernamePassword?

    var disposeBag = DisposeBag()

    public required init(builder: ApiApplicationRequestBuilding,
                         parser: ApiApplicationResponseParsing,
                         executor: RequestExecuting = RequestExecutor()) {
        self.builder = builder
        self.executor = executor
        self.parser = parser
    }

    public convenience init(builder: ApiApplicationRequestBuilding,
                            parser: ApiApplicationResponseParsing,
                            executor: RequestExecuting = RequestExecutor(),
                            credentials: UsernamePassword? = nil) {
        self.init(builder: builder, parser: parser, executor: executor)
        self.credentials = credentials
    }

    public func observe() -> Observable<LoginResult> {
        return Observable.create { observer in
            let request: Request
            do {
                request = try self.builder.make(for: .login, credentials: self.credentials)
            }
            catch {
                observer.onError(error)
                return Disposables.create()
            }

            self.executor
                .execute(request)
                .subscribe(onNext: {
                    do {
                        observer.onNext(try self.parser.parseLoggedIn(from: $0))
                    }
                    catch {
                        observer.onNext(.failed)
                        observer.onError(error)
                    }
                })
                .disposed(by: self.disposeBag)

            return Disposables.create()
        }
    }
}

public enum LoginResult {
    case failed
    case authenticationRequired
    case success
}
