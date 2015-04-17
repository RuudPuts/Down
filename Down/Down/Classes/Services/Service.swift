//
//  Service.swift
//  Down
//
//  Created by Ruud Puts on 14/03/15.
//  Copyright (c) 2015 Ruud Puts. All rights reserved.
//

import UIKit

class Service: NSObject {
    
    var lastRefresh: NSDate?
    
    var listeners: [Listener]
    
    override init() {
        self.listeners = [Listener]()
    }
    
    internal func addListener(listener: Listener) {
        // TODO: Verify listener type
        self.listeners.append(listener)
    }
    
    internal func removeListener(listener: Listener) {
        // TODO: Implement
    }
    
    func refreshCompleted() {
        self.lastRefresh = NSDate()
    }
   
}

extension Array {
    mutating func removeObject<T: Equatable>(object: T) {
//        var index: Int?
//        for (idx, objectToCompare) in enumerate(self) {
//            if let to = objectToCompare as? U {
//                if object == to {
//                    index = idx
//                }
//            }
//        }
//        
//        if(index) {
//            self.removeAtIndex(index!)
//        }
    }
}