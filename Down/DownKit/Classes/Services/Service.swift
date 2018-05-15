//
//  Service.swift
//  Down
//
//  Created by Ruud Puts on 14/03/15.
//  Copyright (c) 2015 Ruud Puts. All rights reserved.
//

import UIKit

// TODO: Make a protocol
public class Service {
    
    public var lastRefresh: Date?
    var listeners = [ServiceListener]()
    internal var started = false
    
    public func addListener(_ listener: ServiceListener) {
        listeners.append(listener)
    }
    
    public func removeListener(_ listener: ServiceListener) {
        for idx in 0...listeners.count {
            if listeners[idx].isEqualTo(listener) {
                listeners.remove(at: idx)
            }
        }
    }
    
    public func startService() {
        started = true
    }

    public func stopService() {
        started = false
    }
    
    internal func refreshCompleted() {
        lastRefresh = Date()
    }
   
}
