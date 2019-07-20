//
//  RxExtensions.swift
//  DownKit
//
//  Created by Ruud Puts on 01/12/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import RxSwift

public extension PrimitiveSequenceType where Self.Trait == RxSwift.SingleTrait {
    func asVoid() -> Single<Void> {
        return map { _ in }
    }
}

public extension Observable {
    func asVoid() -> Observable<Void> {
        return map { _ in }
    }
}
