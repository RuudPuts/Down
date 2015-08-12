//
//  SickbeardHistoryItem.swift
//  Down
//
//  Created by Ruud Puts on 08/04/15.
//  Copyright (c) 2015 Ruud Puts. All rights reserved.
//

import Foundation

public class SickbeardHistoryItem: SickbeardItem {
    var resource: String!
    
    init(_ tvdbId: Int, _ showName: String, _ season: Int, _ episode: Int, _ status: String, _ resource: String) {
        super.init(tvdbId, showName, season, episode: episode, status)
        
        self.resource = resource
    }
}