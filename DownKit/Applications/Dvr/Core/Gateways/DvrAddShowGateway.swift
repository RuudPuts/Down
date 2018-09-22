//
//  DvrAddShowGateway.swift
//  DownKit
//
//  Created by Ruud Puts on 02/08/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import RxSwift

public class DvrAddShowGateway: DvrRequestGateway {
    var builder: DvrRequestBuilding
    var executor: RequestExecuting
    var parser: DvrResponseParsing

    var show: DvrShow!
    var status: DvrEpisodeStatus!

    var disposeBag = DisposeBag()

    public required init(builder: DvrRequestBuilding, parser: DvrResponseParsing, executor: RequestExecuting = RequestExecutor()) {
        self.builder = builder
        self.executor = executor
        self.parser = parser
    }

    public convenience init(show: DvrShow, status: DvrEpisodeStatus = .skipped, builder: DvrRequestBuilding, parser: DvrResponseParsing, executor: RequestExecuting = RequestExecutor()) {
        self.init(builder: builder, parser: parser, executor: executor)
        self.show = show
        self.status = status
    }

    public func observe() -> Observable<Bool> {
        return Observable.create { observer in
            let request: Request
            do {
                request = try self.builder.make(for: .addShow(self.show, self.status))
            }
            catch {
                observer.onError(error)
                return Disposables.create()
            }

            self.executor
                .execute(request)
                .subscribe(onNext: {
                    do {
                        observer.onNext(try self.parser.parseAddShow(from: $0))
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
