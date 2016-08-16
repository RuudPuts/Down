//
//  Service.swift
//  Down
//
//  Created by Ruud Puts on 14/03/15.
//  Copyright (c) 2015 Ruud Puts. All rights reserved.
//

import UIKit

public class Service {
    
    public var lastRefresh: NSDate?
    var listeners = [ServiceListener]()
    
    public func addListener(listener: ServiceListener) {
        listeners.append(listener)
    }
    
    public func removeListener(listener: ServiceListener) {
        for i in 0...listeners.count {
            if listeners[i].isEqualTo(listener) {
                listeners.removeAtIndex(i)
                break
            }
        }
    }
    
    public func startService() {
    }

    public func stopService() {
    }
    
    internal func refreshCompleted() {
        lastRefresh = NSDate()
    }
   
}