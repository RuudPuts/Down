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
    public var status = SickbeardShowStatus.Stopped
    internal var _seasons = List<SickbeardSeason>()
    
    public dynamic var name = "" {
        didSet {
            _simpleName = name.simple()
        }
    }
    internal dynamic var _simpleName = ""
    
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
        for season in seasons {
            episodes.appendContentsOf(season.episodes)
        }
        
        return episodes
    }
    
    public var downloadedEpisodes: [SickbeardEpisode] {
        var episodes = [SickbeardEpisode]()
        for season in seasons {
            episodes.appendContentsOf(season.downloadedEpisodes)
        }
        
        return episodes
    }
    
    public var banner: UIImage? {
        return ImageProvider.bannerForShow(tvdbId)
    }

    internal var hasBanner: Bool {
        return ImageProvider.hasBannerForShow(tvdbId)
    }

    public var poster: UIImage? {
        return ImageProvider.posterForShow(tvdbId)
    }
    
    public var posterThumbnail: UIImage? {
        return ImageProvider.posterThumbnailForShow(tvdbId)
    }

    internal var hasPoster: Bool {
        return ImageProvider.hasPosterForShow(tvdbId)
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
    
    public func nextAiringEpisode() -> SickbeardEpisode? {
        let today = NSDate().dateWithoutTime()
        
        for season in seasons {
            guard season.id > 0 else {
                continue
            }
            
            if let lastEpisodeAirDate = season.episodes.last?.airDate {
                guard lastEpisodeAirDate > today else {
                    // Last episode of the season, no need to loop
                    continue
                }
            }
            
            for episode in season.episodes {
                if let airDate = episode.airDate where airDate >= today {
                    return episode
                }
            }
        }
        
        return nil
    }
    
}

extension String {
    
    func simple() -> String {
        var simpleString = self
        [".", "'", ":", "(", ")", "&"].forEach {
            simpleString = simpleString.stringByReplacingOccurrencesOfString($0, withString: "")
        }
        
        return simpleString
    }
    
}