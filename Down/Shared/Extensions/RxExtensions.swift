//
//  RxExtensions.swift
//  Down
//
//  Created by Ruud Puts on 01/12/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import RxCocoa

extension SharedSequenceConvertibleType where Self.SharingStrategy == RxCocoa.DriverSharingStrategy {
    func asVoid() -> Driver<Void> {
        return map { _ in }
    }
}
