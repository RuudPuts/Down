//
//  SickbeardItem.swift
//  Down
//
//  Created by Ruud Puts on 19/07/15.
//  Copyright © 2015 Ruud Puts. All rights reserved.
//

import Foundation

public class SickbeardItem {
    var tvdbId: Int!
    public var showName: String!
    public var season: Int!
    public var episode: Int!
    public var episodeName: String?
    var status: SickbeardItemStatus!
    
    public enum SickbeardItemStatus {
        case Snatched
        case Downloading
        case Finished
        case Failed
        case Missed
        case Comming
    }
    
    init (_ tvdbId: Int, _ showName: String, _ season: Int, _ episode: Int, _ episodeName: String?, _ status: String) {
        self.tvdbId = tvdbId
        self.showName = showName
        self.season = season
        self.episode = episode
        self.episodeName = episodeName
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
    
    public var displayName: String! {
        return String(format: "%@ - S%02dE%02d", self.showName, self.season, self.episode)
    }
    
    public var banner: UIImage? {
        return ImageProvider.bannerForShow(self.tvdbId)
    }
    
    internal var hasBanner: Bool {
        return ImageProvider.hasBannerForShow(self.tvdbId)
    }
    
}