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
    public dynamic var uniqueId = NSUUID().UUIDString
    public dynamic var id = 0
    public dynamic var name = ""
    public dynamic var airDate: NSDate? = nil
    public dynamic var quality = ""
    public dynamic var status = ""
    public dynamic var filename = ""
    public dynamic var plot = ""
    
    public dynamic weak var show: SickbeardShow?
    public dynamic weak var season: SickbeardSeason?
    
    // MARK: Warning: set uniqueId before storing
    
//    public convenience init(id: String, season: SickbeardSeason, show: SickbeardShow) {
//        self.init()
//        
//        self.id = id
//        self.show = show
//        self.season = season
//        uniqueId = "\(show.tvdbId)-\(season.id)-\(id)"//objectHash = NSUUID().UUIDString
//    }
    
    // MARK: Realm
    
    public override static func primaryKey() -> String {
        return "uniqueId"
    }
    
    // MARK: Public getters
    
    public var title: String {
        var title = name
        if season != nil && show != nil {
            title = "\(show!.name) - S\(season!.id)E\(id) - \(name)"
        }
        return title
    }
    
}