//
//  Connector.swift
//  Down
//
//  Created by Ruud Puts on 18/12/15.
//  Copyright © 2015 Ruud Puts. All rights reserved.
//

import Foundation

public protocol Connector {
    
    func validateHost(host: String, completion: (Bool) -> (Void))
    
}