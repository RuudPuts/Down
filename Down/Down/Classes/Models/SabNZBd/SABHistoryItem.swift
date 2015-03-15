//
//  SABHistoryItem.swift
//  Down
//
//  Created by Ruud Puts on 14/03/15.
//  Copyright (c) 2015 Ruud Puts. All rights reserved.
//

import UIKit

class SABHistoryItem: SABItem {
   
    let size: String!
    
    enum SABHistoryItemStatus {
        case Queued
        case Downloading
        case Downloaded
    }
    
    init(identifier: String, filename: String, category: String, size: String) {
        self.size = size
        
        super.init(identifier: identifier, filename: filename, category: category)
    }
    
}
