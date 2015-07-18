//
//  Service.swift
//  Down
//
//  Created by Ruud Puts on 14/03/15.
//  Copyright (c) 2015 Ruud Puts. All rights reserved.
//

import UIKit

class Service {
    
    var lastRefresh: NSDate?
    var listeners = [Listener]()
    
    init() {
    }
    
    internal func addListener(listener: Listener) {
        listeners.append(listener)
    }
    
    internal func removeListener(listener: Listener) {
        for i in 0...listeners.count {
            if (listeners[i].isEqualTo(listener)) {
                listeners.removeAtIndex(i)
                break
            }
        }
    }
    
    func refreshCompleted() {
        lastRefresh = NSDate()
    }
   
}