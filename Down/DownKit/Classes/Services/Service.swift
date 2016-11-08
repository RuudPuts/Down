//
//  Service.swift
//  Down
//
//  Created by Ruud Puts on 14/03/15.
//  Copyright (c) 2015 Ruud Puts. All rights reserved.
//

import UIKit

open class Service {
    
    open var lastRefresh: Date?
    var listeners = [ServiceListener]()
    internal var started = false
    
    open func addListener(_ listener: ServiceListener) {
        listeners.append(listener)
    }
    
    open func removeListener(_ listener: ServiceListener) {
        for i in 0...listeners.count {
            if listeners[i].isEqualTo(listener) {
                listeners.remove(at: i)
                break
            }
        }
    }
    
    open func startService() {
        started = true
    }

    open func stopService() {
        started = false
    }
    
    internal func refreshCompleted() {
        lastRefresh = Date()
    }
   
}
