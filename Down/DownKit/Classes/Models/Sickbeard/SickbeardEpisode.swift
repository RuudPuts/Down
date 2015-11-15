//
//  SickbeardShow.swift
//  Down
//
//  Created by Ruud Puts on 06/09/15.
//  Copyright © 2015 Ruud Puts. All rights reserved.
//

import Foundation
import RealmSwift

public class SickbeardEpisode: Object {
    public dynamic var uniqueId = ""
    public dynamic var id = ""
    public dynamic var name = ""
    public dynamic var airDate = ""
    public dynamic var quality = ""
    public dynamic var status = ""
    public dynamic var filename = ""
    
    weak public dynamic var show: SickbeardShow?
    weak public dynamic var season: SickbeardSeason?
    
    public convenience init(id: String, season: SickbeardSeason, show: SickbeardShow) {
        self.init()
        
        self.id = id
        self.show = show
        self.season = season
        uniqueId = "\(show.tvdbId)-\(season.id)-\(id)"//objectHash = NSUUID().UUIDString
    }
    
    // MARK: Realm
    
    public override static func primaryKey() -> String {
        return "uniqueId"
    }
    
    // MARK: Public getters
    
//    public var displayName: String {
//        var displayName = name
////        if season != nil && show != nil {
////            displayName = "\(show!.name) - S\(season!.id)E\(id) - \(name)"
////        }
//        return displayName
//    }
    
}