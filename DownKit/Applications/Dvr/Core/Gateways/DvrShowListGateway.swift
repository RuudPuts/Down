//
//  DvrShowListGateway.swift
//  Down
//
//  Created by Ruud Puts on 06/01/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import RxSwift

public class DvrShowListGateway: DvrRequestGateway {
    var builder: DvrRequestBuilding
    var executor: RequestExecuting
    var parser: DvrResponseParsing

    var disposeBag = DisposeBag()
    
    public required init(builder: DvrRequestBuilding, parser: DvrResponseParsing, executor: RequestExecuting = RequestExecutor()) {
        self.builder = builder
        self.executor = executor
        self.parser = parser
    }
    
    public func observe() -> Observable<[DvrShow]> {
        return Observable.create { observer in
            let request: Request
            do {
                request = try self.builder.make(for: .showList)
            }
            catch {
                observer.onError(error)
                return Disposables.create()
            }

            self.executor
                .execute(request)
                .subscribe(onNext: {
                    do {
                        observer.onNext(try self.parser.parseShows(from: $0))
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
