//
//  ApiApplicationApiKeyGateway.swift
//  DownKit
//
//  Created by Ruud Puts on 26/06/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import RxSwift

public class ApiApplicationApiKeyGateway: ApiApplicationRequestGateway {
    var builder: ApiApplicationRequestBuilding
    var executor: RequestExecuting
    var parser: ApiApplicationResponseParsing

    var disposeBag = DisposeBag()

    public required init(builder: ApiApplicationRequestBuilding, parser: ApiApplicationResponseParsing, executor: RequestExecuting = RequestExecutor()) {
        self.builder = builder
        self.executor = executor
        self.parser = parser
    }

    public func observe() -> Observable<String?> {
        return Observable.create { observer in
            let request: Request
            do {
                request = try self.builder.make(for: .apiKey, credentials: nil)
            }
            catch {
                observer.onError(error)
                return Disposables.create()
            }

            self.executor
                .execute(request)
                .subscribe(onNext: {
                    do {
                        observer.onNext(try self.parser.parseApiKey(from: $0))
                    }
                    catch {
                        observer.onError(error)
                    }
                })
                .disposed(by: self.disposeBag)

            return Disposables.create()
        }
    }
}
