//
//  SickbeardShow.swift
//  Down
//
//  Created by Ruud Puts on 06/09/15.
//  Copyright © 2015 Ruud Puts. All rights reserved.
//

import Foundation

public class SickbeardShow {
    public var tvdbId: String!
    public var name: String!
    public var status: SickbeardShowStatus!
    public var seasons = [String: SickbeardSeason]()
    
    public enum SickbeardShowStatus: Int {
        case Stopped = 0
        case Active = 1
    }
    
    init (_ tvdbId: String, _ name: String, _ paused: Int) {
        self.tvdbId = tvdbId
        self.name = name
        self.status = paused == 1 ? .Stopped : .Active
    }
    
    // Properties
    
    public var banner: UIImage? {
        return ImageProvider.bannerForShow(self.tvdbId)
    }
    
    internal var hasBanner: Bool {
        return ImageProvider.hasBannerForShow(self.tvdbId)
    }
    
    public var poster: UIImage? {
        return ImageProvider.posterForShow(self.tvdbId)
    }
    
    internal var hasPoster: Bool {
        return ImageProvider.hasPosterForShow(self.tvdbId)
    }
    
    // Methods
    
    internal func addSeason(season: SickbeardSeason) {
        season.show = self
        
        seasons[season.id] = season
    }
    
    public func getEpisode(seasonId: String, _ episodeNr: Int) -> SickbeardEpisode? {
        var episode: SickbeardEpisode?
        if let season = seasons[seasonId] {
            episode = season.episodes[episodeNr - 1]
        }
        
        return episode
    }
    
}