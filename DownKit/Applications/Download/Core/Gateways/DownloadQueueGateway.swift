//
//  DownloadQueueGateway.swift
//  Down
//
//  Created by Ruud Puts on 22/06/2018
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import RxSwift

public class DownloadQueueGateway: DownloadRequestGateway {
    var builder: DownloadRequestBuilding
    var executor: RequestExecuting
    var parser: DownloadResponseParsing

    var disposeBag = DisposeBag()
    
    public required init(builder: DownloadRequestBuilding, parser: DownloadResponseParsing, executor: RequestExecuting = RequestExecutor()) {
        self.builder = builder
        self.executor = executor
        self.parser = parser
    }
    
    public func observe() -> Observable<DownloadQueue> {
        return Observable.create { observer in
            let request: Request
            do {
                request = try self.builder.make(for: .queue)
            }
            catch {
                observer.onError(error)
                return Disposables.create()
            }

            self.executor
                .execute(request)
                .subscribe(onNext: {
                    do {
                        observer.onNext(try self.parser.parseQueue(from: $0))
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
