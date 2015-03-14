//
//  SABItem.swift
//  Down
//
//  Created by Ruud Puts on 14/03/15.
//  Copyright (c) 2015 Ruud Puts. All rights reserved.
//

import UIKit

class SABItem: NSObject {
    
    let identifier: String!
    let filename: String!
    var name: String?
    let category: String?
    
    init(identifier: String, filename: String) {
        self.identifier = identifier
        self.filename = filename
    }
   
}
