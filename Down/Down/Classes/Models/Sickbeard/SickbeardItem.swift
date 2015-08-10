//
//  SickbeardItem.swift
//  Down
//
//  Created by Ruud Puts on 19/07/15.
//  Copyright © 2015 Ruud Puts. All rights reserved.
//

import Foundation

class SickbeardItem {
    var tvdbId: Int!
    var showName: String!
    var season: Int!
    var episode: Int!
    var status: SickbeardItemStatus!
    
    enum SickbeardItemStatus {
        case Snatched
        case Downloading
        case Finished
        case Failed
        case Missed
        case Comming
    }
    
    init (_ tvdbId: Int, _ showName: String, _ season: Int, episode: Int, _ status: String) {
        self.tvdbId = tvdbId
        self.showName = showName
        self.season = season
        self.episode = episode
        self.status = stringToStatus(status)
    }
    
    private func stringToStatus(string: String) -> SickbeardItemStatus! {
        var status = SickbeardItemStatus.Snatched
        
        switch (string) {
        case "Downloaded":
            status = SickbeardItemStatus.Finished
            break
        case "Snatched":
            status = SickbeardItemStatus.Snatched
            break
            
        default:
            break
        }
        
        return status
    }
    
    var displayName: String! {
        return String(format: "%@ - S%02dE%02d", self.showName, self.season, self.episode)
    }
    
}