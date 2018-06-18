//
//  Observable.swift
//  DownKit
//
//  Created by Ruud Puts on 18/06/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import RxSwift

public extension Observable {
    func withInterval(interval: RxTimeInterval) -> Observable<Element> {
        return Observable<Int>.create { (observer) -> Disposable in
            observer.onNext(0)
            
            let interval = Observable<Int>
                .interval(interval, scheduler: MainScheduler.instance)
                .subscribe(observer)
            
            return Disposables.create([interval])
            }
            .flatMapLatest { _ in self }
    }
}
