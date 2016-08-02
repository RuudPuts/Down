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
    
    public func getPosterThumbnail(completion: (thumbnail: UIImage?) -> Void) {
        let tvdbId = self.tvdbId
        
        let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)
        dispatch_async(queue) { 
            let thumbnail = ImageProvider.posterThumbnailForShow(tvdbId)
            dispatch_async(dispatch_get_main_queue(), { 
                completion(thumbnail: thumbnail)
            })
        }
    }

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
        let now = NSDate()
        
        for season in seasons {
            if let lastEpisodeAirDate = season.episodes.last?.airDate where
                lastEpisodeAirDate.compare(now) == .OrderedAscending {
                // Last episode of the season, no need to loop
                continue
            }
            
            for episode in season.episodes {
                if let airDate = episode.airDate where airDate.compare(now) == .OrderedDescending {
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