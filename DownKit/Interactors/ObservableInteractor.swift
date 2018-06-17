//
//  ObservableInteractor.swift
//  DownKit
//
//  Created by Ruud Puts on 17/06/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import RxSwift

public protocol ObservableInteractor {
    associatedtype Element
    
    func execute() -> Observable<Element>
}
