//
//  SickbeardHistoryItem.swift
//  Down
//
//  Created by Ruud Puts on 08/04/15.
//  Copyright (c) 2015 Ruud Puts. All rights reserved.
//

import Foundation

class SickbeardHistoryItem {    
    var tvdbId: Int!
    var showName: String!
    var status: SickbeardHistoryItemStatus!
    var season: Int!
    var episode: Int!
    var resource: String!
    
    enum SickbeardHistoryItemStatus {
        case Snatched
        case Downloading
        case Finished
        case Failed
    }
    
    init(_ tvdbId: Int, _ showName: String, _ status: String, _ season: Int, _ episode: Int, _ resource: String) {
        self.tvdbId = tvdbId
        self.showName = showName
        self.status = stringToStatus(status)
        self.season = season
        self.episode = episode
        self.resource = resource
    }
    
    private func stringToStatus(string: String) -> SickbeardHistoryItemStatus! {
        var status = SickbeardHistoryItemStatus.Snatched
        
        switch (string) {
        case "Downloaded":
            status = SickbeardHistoryItemStatus.Finished
        case "Snatched":
            status = SickbeardHistoryItemStatus.Snatched
            
        default:
            status = SickbeardHistoryItemStatus.Snatched
        }
        
        return status
    }
    
    var displayName: String! {
        return String(format: "%@ - S%02dE%02d", self.showName, self.season, self.episode)
    }
}