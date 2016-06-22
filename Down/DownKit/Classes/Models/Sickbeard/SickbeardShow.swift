//
//  SickbeardShow.swift
//  Down
//
//  Created by Ruud Puts on 06/09/15.
//  Copyright © 2015 Ruud Puts. All rights reserved.
//

import Foundation
import RealmSwift

public class SickbeardShow: Object {
    public dynamic var tvdbId = 0
    public dynamic var name = ""
    public var status = SickbeardShowStatus.Stopped
    internal var _seasons = List<SickbeardSeason>()
    
    public enum SickbeardShowStatus: Int {
        case Stopped = 0
        case Active = 1
    }
    
    // Realm
    
    public override static func primaryKey() -> String? {
        return "tvdbId"
    }
    
    // Properties
    
    public var seasons: [SickbeardSeason] {
        let sortedSeasons = Array(_seasons).sort {
            $0.id < $1.id
        }
        
        return Array(sortedSeasons)
    }
    
    public var allEpisodes: [SickbeardEpisode] {
        var episodes = [SickbeardEpisode]()
        for season in _seasons {
            episodes.appendContentsOf(season.episodes)
        }
        
        return episodes
    }
    
    public var downloadedEpisodes: [SickbeardEpisode] {
        var episodes = [SickbeardEpisode]()
        for season in _seasons {
            episodes.appendContentsOf(season.downloadedEpisodes)
        }
        
        return episodes
    }
    
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

    public func getSeason(seasonId: Int) -> SickbeardSeason? {
        for season in _seasons {
            if season.id == seasonId {
                return season
            }
        }

        return nil
    }

    public func getEpisode(seasonId: Int, _ episodeNr: Int) -> SickbeardEpisode? {
        if let season = getSeason(seasonId) {
            let episodeIndex = episodeNr - 1
            guard season.episodes.count > episodeIndex else {
                return nil
            }
            
            return season.episodes[episodeIndex]
        }
        
        return nil
    }
    
}