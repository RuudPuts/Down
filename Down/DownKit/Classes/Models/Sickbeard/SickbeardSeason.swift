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
    public dynamic var id = ""
    public var episodes = List<SickbeardEpisode>()
    
    weak var show: SickbeardShow?
    
//    public var shows: [SickbeardShow] {
//        // Realm doesn't persist this property because it only has a getter defined
//        // Define "owners" as the inverse relationship to Person.dogs
//        return linkingObjects(SickbeardShow.self, forProperty: "seasons")
//    }
//    
//    public var show: SickbeardShow? {
//        return shows.first
//    }
    
    init (id: String) {
        self.id = id
        
        super.init()
    }
    
    public required init() {
        super.init()
    }
    
    // Realm
    
    public override static func primaryKey() -> String {
        return "id"
    }
    
//    public override static func ignoredProperties() -> [String] {
//        return ["show"]
//    }
    
    // Episodes
    
    internal func addEpisode(episode: SickbeardEpisode) {
        episode.season = self
        episode.show = show
        
        episodes.append(episode)
    }
    
}