//
//  SickbeardListener.swift
//  Down
//
//  Created by Ruud Puts on 12/04/15.
//  Copyright (c) 2015 Ruud Puts. All rights reserved.
//

import Foundation

@objc protocol SickbeardListener: Listener {
    
    func sickbeardHistoryUpdated()
    
}
