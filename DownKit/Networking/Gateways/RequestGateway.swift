//
//  RequestGateway.swift
//  Down
//
//  Created by Ruud Puts on 04/01/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import RxSwift

public protocol RequestGateway {
    associatedtype ResultType
    
    func observe() -> Observable<ResultType>
}
