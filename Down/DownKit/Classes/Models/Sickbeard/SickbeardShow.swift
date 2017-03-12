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
    public dynamic var airs = ""
    public dynamic var network = ""
    
    public var status: SickbeardShowStatus {
        get {
            return SickbeardShowStatus(rawValue: statusString) ?? .Ended
        }
        set {
            statusString = newValue.rawValue
        }
    }
    fileprivate dynamic var statusString = ""
    
    public var quality: SickbeardShowQuality {
        get {
            return SickbeardShowQuality(rawValue: qualityString) ?? .Wildcard
        }
        set {
            qualityString = newValue.rawValue
        }
    }
    fileprivate dynamic var qualityString = ""
    
    public dynamic var name = "" {
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
    
    public override static func primaryKey() -> String? {
        return "tvdbId"
    }
    
    // Properties
    
    public var seasons: [SickbeardSeason] {
        let sortedSeasons = Array(_seasons).sorted {
            $0.id < $1.id
        }
        
        return Array(sortedSeasons)
    }
    
    public var allEpisodes: [SickbeardEpisode] {
        var episodes = [SickbeardEpisode]()
        for season in seasons {
            episodes.append(contentsOf: season.episodes)
        }
        
        return episodes
    }
    
    public var downloadedEpisodes: [SickbeardEpisode] {
        var episodes = [SickbeardEpisode]()
        for season in seasons {
            episodes.append(contentsOf: season.downloadedEpisodes)
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
    
    internal var percentageDownloaded: Float {
//        var episodes: Float
//        _seasons.forEach { season in
//            episodes += Float(season._episodes.count)
//        }
//
//        var downloadedEpisodes: Float
////        _seasons.forEach {
////            downloadedEpisodes += Float($0._episodes.filter(NSPredicate(block: { episode, _ in
////                return (episode as! SickbeardEpisode).status == .Downloaded
////            })).count)
////        }
        
//        return downloadedEpisodes / episodes
        
        return 0.0
    }

    // Methods

    public func getSeason(_ seasonId: Int) -> SickbeardSeason? {
        for season in _seasons {
            if season.id == seasonId {
                return season
            }
        }

        return nil
    }
    
    public func nextAiringEpisode() -> SickbeardEpisode? {
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
