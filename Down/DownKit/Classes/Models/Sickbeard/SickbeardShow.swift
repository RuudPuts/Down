//
//  SickbeardShow.swift
//  Down
//
//  Created by Ruud Puts on 06/09/15.
//  Copyright © 2015 Ruud Puts. All rights reserved.
//

import Foundation
import RealmSwift

open class SickbeardShow: Object {
    open dynamic var tvdbId = 0
    open dynamic var airs = ""
    open dynamic var network = ""
    
    open var status: SickbeardShowStatus {
        get {
            return SickbeardShowStatus(rawValue: statusString) ?? .Ended
        }
        set {
            statusString = newValue.rawValue
        }
    }
    fileprivate dynamic var statusString = ""
    
    open var quality: SickbeardShowQuality {
        get {
            return SickbeardShowQuality(rawValue: qualityString) ?? .Wildcard
        }
        set {
            qualityString = newValue.rawValue
        }
    }
    fileprivate dynamic var qualityString = ""
    
    open dynamic var name = "" {
        didSet {
            _simpleName = name.simple
        }
    }
    
    internal dynamic var _simpleName = ""
    internal var _seasons = List<SickbeardSeason>()
    
    public enum SickbeardShowStatus: String {
        case Continuing = "Continuing"
        case Ended = "Ended"
    }
    
    public enum SickbeardShowQuality: String {
        case Wildcard = "Any"
        case Custom = "Custom"
        case HD = "HD"
        case HD1080p = "HD1080p"
        case HD720p = "HD720p"
        case SD = "SD"
    }
    
    // Realm
    
    open override static func primaryKey() -> String? {
        return "tvdbId"
    }
    
    // Properties
    
    open var seasons: [SickbeardSeason] {
        let sortedSeasons = Array(_seasons).sorted {
            $0.id < $1.id
        }
        
        return Array(sortedSeasons)
    }
    
    open var allEpisodes: [SickbeardEpisode] {
        var episodes = [SickbeardEpisode]()
        for season in seasons {
            episodes.append(contentsOf: season.episodes)
        }
        
        return episodes
    }
    
    open var downloadedEpisodes: [SickbeardEpisode] {
        var episodes = [SickbeardEpisode]()
        for season in seasons {
            episodes.append(contentsOf: season.downloadedEpisodes)
        }
        
        return episodes
    }
    
    open var banner: UIImage? {
        return ImageProvider.bannerForShow(tvdbId)
    }

    internal var hasBanner: Bool {
        return ImageProvider.hasBannerForShow(tvdbId)
    }

    open var poster: UIImage? {
        return ImageProvider.posterForShow(tvdbId)
    }
    
    open var posterThumbnail: UIImage? {
        return ImageProvider.posterThumbnailForShow(tvdbId)
    }

    internal var hasPoster: Bool {
        return ImageProvider.hasPosterForShow(tvdbId)
    }

    // Methods

    open func getSeason(_ seasonId: Int) -> SickbeardSeason? {
        for season in _seasons {
            if season.id == seasonId {
                return season
            }
        }

        return nil
    }
    
    open func nextAiringEpisode() -> SickbeardEpisode? {
        let today = Date().withoutTime()
        
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
                if let airDate = episode.airDate , airDate >= today {
                    return episode
                }
            }
        }
        
        return nil
    }
    
}
