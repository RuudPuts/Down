//
//  ObservableInteractor.swift
//  DownKit
//
//  Created by Ruud Puts on 17/06/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import RxSwift
import Result

public protocol ObservableInteractor {
    associatedtype Element
    
    func observe() -> Single<Result<Element, DownKitError>>
}
