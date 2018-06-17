//
//  ApplicationFactory.swift
//  DownKit
//
//  Created by Ruud Puts on 17/06/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import Foundation

public protocol ApplicationProducing {
    func makeDvr(type: DvrApplicationType) -> DvrApplication
    
    init()
}

public final class ApplicationFactory: ApplicationProducing {
    public init() {}
    
    public func makeDvr(type: DvrApplicationType) -> DvrApplication {
        switch type {
        case .sickbeard:
            return DvrApplication(type: .sickbeard,
                                  host: "http://192.168.2.100:8081",
                                  apiKey: "e9c3be0f3315f09d7ceae37f1d3836cd")
        }
    }
}
