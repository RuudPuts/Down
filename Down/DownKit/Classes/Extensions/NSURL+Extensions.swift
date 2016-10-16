//
//  NSURL+Extensions.swift
//  Down
//
//  Created by Ruud Puts on 17/08/16.
//  Copyright © 2016 Ruud Puts. All rights reserved.
//

import Foundation

extension URL {
    
    func prefixScheme() -> URL {
        if URLComponents(url: self, resolvingAgainstBaseURL: false) != nil {
            let httpScheme = "http://"
            var urlString = self.absoluteString
            
            if !urlString.hasPrefix(httpScheme) {
                urlString = httpScheme + urlString
            }
            
            return URL(string: urlString)!
        }
        
        return self
    }
    
}
