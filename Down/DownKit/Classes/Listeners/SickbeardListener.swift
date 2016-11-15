//
//  SickbeardListener.swift
//  Down
//
//  Created by Ruud Puts on 12/04/15.
//  Copyright (c) 2015 Ruud Puts. All rights reserved.
//

import Foundation

public protocol SickbeardListener: ServiceListener {
    
    func sickbeardShowCacheUpdated()
    func sickbeardShowAdded(_ show: SickbeardShow)
    
}

extension SickbeardListener {
    
    public func sickbeardShowCacheUpdated() {
        
    }
    
    public func sickbeardShowAdded(_ show: SickbeardShow) {
        
    }
    
}
