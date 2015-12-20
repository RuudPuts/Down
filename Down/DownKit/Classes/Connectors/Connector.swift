//
//  Connector.swift
//  Down
//
//  Created by Ruud Puts on 18/12/15.
//  Copyright © 2015 Ruud Puts. All rights reserved.
//

import Foundation

public protocol Connector {
    
    var host: String? { get set }
    
    func validateHost(host: String, completion: (hostValid: Bool, apiKey: String?) -> (Void))
    
    func fetchApiKey(completion: (String?) -> (Void))
    func fetchApiKey(username username: String?, password: String?, completion: (String?) -> (Void))
    
}