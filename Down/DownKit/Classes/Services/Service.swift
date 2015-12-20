//
//  Service.swift
//  Down
//
//  Created by Ruud Puts on 14/03/15.
//  Copyright (c) 2015 Ruud Puts. All rights reserved.
//

import UIKit

public class Service {
    
    var connector: Connector?
    public var lastRefresh: NSDate?
    var listeners = [ServiceListener]()
    
    init() {
    }
    
    public func addListener(listener: ServiceListener) {
        listeners.append(listener)
    }
    
    public func removeListener(listener: ServiceListener) {
        for i in 0...listeners.count {
            if (listeners[i].isEqualTo(listener)) {
                listeners.removeAtIndex(i)
                break
            }
        }
    }
    
    func checkHostReachability(completion: (hostReachable: Bool, requiredAuthentication: Bool) -> (Void)) {
        preconditionFailure("This method must be overridden")
    }
    
    internal func refreshCompleted() {
        lastRefresh = NSDate()
    }
   
}