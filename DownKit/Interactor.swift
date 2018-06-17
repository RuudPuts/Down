//
//  Interactor.swift
//  DownKit
//
//  Created by Ruud Puts on 16/06/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import RxSwift

public protocol Interactor {
    associatedtype Element
    
    func asObservable() -> Observable<Element>
}

public protocol RequestInteractor: Interactor {
    associatedtype Gateway: RequestGateway
    associatedtype Application: ApiApplication
    
    var application: Application { get }
    var gateway: Gateway { get }
    
    init(application: Application, gateway: Gateway)
}
