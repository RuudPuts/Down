//
//  Service.swift
//  Down
//
//  Created by Ruud Puts on 14/03/15.
//  Copyright (c) 2015 Ruud Puts. All rights reserved.
//

import UIKit

class Service: NSObject {
    
    let baseUrl: String
    let apiKey: String!
    
    var listeners: [Listener]
    
    init(baseUrl: String!, apiKey: String!) {
        self.baseUrl = baseUrl
        self.apiKey = apiKey
        self.listeners = [Listener]()
    }
    
    internal func addListener(listener: Listener) {
        // TODO: Verify listener type
        self.listeners.append(listener)
    }
    
    internal func removeListener(listener: Listener) {
        // TODO: Implement
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