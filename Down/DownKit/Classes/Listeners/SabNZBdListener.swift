//
//  SabNZBdListener.swift
//  Down
//
//  Created by Ruud Puts on 14/03/15.
//  Copyright (c) 2015 Ruud Puts. All rights reserved.
//

import UIKit

public protocol SabNZBdListener: ServiceListener {
   
    func sabNZBdQueueUpdated()
    func sabNZBdHistoryUpdated()
    func sabNZBDFullHistoryFetched()
    
}