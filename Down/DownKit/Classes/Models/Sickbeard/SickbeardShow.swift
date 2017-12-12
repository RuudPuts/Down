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
    @objc public dynamic var tvdbId = 0
    @objc public dynamic var airs = ""
    @objc public dynamic var network = ""
    
    public var status: SickbeardShowStatus {
        get {
            return SickbeardShowStatus(rawValue: statusString) ?? .ended
        }
        set {
            statusString = newValue.rawValue
        }
    }
    @objc fileprivate dynamic var statusString = ""
    
    public var quality: SickbeardShowQuality {
        get {
            return SickbeardShowQuality(rawValue: qualityString) ?? .wildcard
        }
        set {
            qualityString = newValue.rawValue
        }
    }
    @objc fileprivate dynamic var qualityString = ""
    
    @objc public dynamic var name = "" {
        didSet {
            _simpleName = name.simple
        }
    }

    // swiftlint:disable identifier_name
    @objc internal dynamic var _simpleName = ""
    // swiftlint:disable identifier_name
    internal var _seasons = List<SickbeardSeason>()
    
    public enum SickbeardShowStatus: String {
        case continuing = "Continuing"
        case ended = "Ended"
    }
    
    public enum SickbeardShowQuality: String {
        case wildcard = "Any"
        case custom = "Custom"
        case hd = "HD"
        case hd1080p = "HD1080p"
        case hd720p = "HD720p"
        case sd = "SD"
    }
    
    // Realm
    
    public override static func primaryKey() -> String? {
        return "tvdbId"
    }
    
    // Properties
    
    public var seasons: [SickbeardSeason] {
        let sortedSeasons = Array(_seasons).sorted {
            $0.identifier < $1.identifier
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

    public var hasBanner: Bool {
        return ImageProvider.hasBannerForShow(tvdbId)
    }

    public var poster: UIImage? {
        return ImageProvider.posterForShow(tvdbId)
    }
    
    public var posterThumbnail: UIImage? {
        return ImageProvider.posterThumbnailForShow(tvdbId)
    }

    public var hasPoster: Bool {
        return ImageProvider.hasPosterForShow(tvdbId)
    }
    
    internal var percentageDownloaded: Int {
        guard _seasons.count > 0 else {
            return 0
        }
        
        var episodes: Double = 0.0
        var downloadedEpisodes: Double = 0.0
        
        _seasons.forEach {
            episodes += Double($0._episodes.count)
            
            let downloadedPredicate = "statusString = \"\(SickbeardEpisode.Status.downloaded)\""
            downloadedEpisodes += Double($0._episodes.filter(downloadedPredicate).count)
        }
        
        return Int(round(downloadedEpisodes / episodes * 100.0))
    }

    // Methods

    public func getSeason(_ seasonId: Int) -> SickbeardSeason? {
        return _seasons.filter { $0.identifier == seasonId }.first
    }
    
    public func nextAiringEpisode() -> SickbeardEpisode? {
        let today = Date().withoutTime()
        
        for season in seasons {
            guard season.identifier > 0 else {
                continue
            }
            
            if let lastEpisodeAirDate = season.episodes.last?.airDate {
                guard lastEpisodeAirDate > today else {
                    // Last episode of the season, no need to loop
                    continue
                }
            }
            
            for episode in season.episodes {
                if let airDate = episode.airDate, airDate >= today {
                    return episode
                }
            }
        }
        
        return nil
    }
    
}
