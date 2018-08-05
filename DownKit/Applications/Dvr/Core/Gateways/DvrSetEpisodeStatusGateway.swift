//
//  DvrSetEpisodeStatusGateway.swift
//  DownKit
//
//  Created by Ruud Puts on 02/08/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import RxSwift

public class DvrSetEpisodeStatusGateway: DvrRequestGateway {
    var builder: DvrRequestBuilding
    var executor: RequestExecuting
    var parser: DvrResponseParsing

    var episode: DvrEpisode!
    var status: DvrEpisode.Status!

    var disposeBag = DisposeBag()

    public required init(builder: DvrRequestBuilding, parser: DvrResponseParsing, executor: RequestExecuting = RequestExecutor()) {
        self.builder = builder
        self.executor = executor
        self.parser = parser
    }

    public func observe() -> Observable<Bool> {
        return Observable.create { observer in
            let request: Request
            do {
                request = try self.builder.make(for: .setEpisodeStatus(self.episode, self.status))
            }
            catch {
                observer.onError(error)
                return Disposables.create()
            }

            self.executor
                .execute(request)
                .subscribe(onNext: {
                    do {
                        observer.onNext(try self.parser.parseSetEpisodeStatus(from: $0))
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
