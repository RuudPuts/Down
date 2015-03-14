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
    
    var listeners: Array<Listener>
    
    init(baseUrl: String) {
        self.baseUrl = baseUrl
        self.listeners = Array<Listener>()
    }
    
    internal func addListener(listener : Listener) {
        // TODO: Verify listener type
        self.listeners.append(listener)
    }
   
}
