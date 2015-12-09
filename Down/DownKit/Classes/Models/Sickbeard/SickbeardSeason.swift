//
//  SickbeardShow.swift
//  Down
//
//  Created by Ruud Puts on 06/09/15.
//  Copyright © 2015 Ruud Puts. All rights reserved.
//

import Foundation
import RealmSwift

public class SickbeardSeason: Object {
    public dynamic var uniqueId = NSUUID().UUIDString
    public dynamic var id = 0
    public var episodes = List<SickbeardEpisode>()
    
    public dynamic weak var show: SickbeardShow?
    
    // Realm
    
    public override static func primaryKey() -> String {
        return "uniqueId"
    }
    
    // Properties
    
    public var sortedEpisodes: Results<SickbeardEpisode> {
        return episodes.sorted("id")
    }
}