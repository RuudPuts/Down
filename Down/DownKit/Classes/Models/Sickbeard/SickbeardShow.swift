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
    public dynamic var tvdbId = ""
    public dynamic var name = ""
    public var status = SickbeardShowStatus.Stopped
//    public let seasons = List<SickbeardSeason>()
    
    public enum SickbeardShowStatus: Int {
        case Stopped = 0
        case Active = 1
    }
    
    init (_ tvdbId: String, _ name: String, _ paused: Int) {
        self.tvdbId = tvdbId
        self.name = name
        self.status = paused == 1 ? .Stopped : .Active
        
        super.init()
    }
    
    public required init() {
        super.init()
    }
    
    // Realm
    
    public override static func primaryKey() -> String? {
        return "tvdbId"
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
//        seasons.append(season)
    }
    
    public func getSeason(seasonId: String) -> SickbeardSeason? {
        var foundSeason: SickbeardSeason?
        
//        for season in seasons {
//            if season.id == seasonId {
//                foundSeason = season
//            }
//        }
        
        return foundSeason
    }
    
    public func getEpisode(seasonId: String, _ episodeNr: Int) -> SickbeardEpisode? {
        var episode: SickbeardEpisode?
        if let season = getSeason(seasonId) {
            episode = season.episodes[episodeNr - 1]
        }
        
        return episode
    }
    
}