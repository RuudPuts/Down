//
//  SabNZBdListener.swift
//  Down
//
//  Created by Ruud Puts on 14/03/15.
//  Copyright (c) 2015 Ruud Puts. All rights reserved.
//

import UIKit

protocol SabNZBdListener: Listener {
   
    func sabNZBdQueueUpdated()
    func sabNZBdHistoryUpdated()
    func sabNZBDFullHistoryFetched()
    
}