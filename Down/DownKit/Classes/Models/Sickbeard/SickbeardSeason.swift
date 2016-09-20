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
    internal var _episodes = List<SickbeardEpisode>()
    
    public dynamic weak var show: SickbeardShow?
    
    // Realm
    
    public override static func primaryKey() -> String {
        return "uniqueId"
    }
    
    // Properties
    
    public var episodes: [SickbeardEpisode] {
        let sortedEpisodes = Array(_episodes).sort {
            $0.id < $1.id
        }
        return sortedEpisodes
    }
    
    public var downloadedEpisodes: [SickbeardEpisode] {
        let filteredEpisodes = Array(_episodes).filter {
            $0.status == .Downloaded
        }
        
        return filteredEpisodes
    }
    
    public var title: String {
        var title = "Season \(id)"
        if id == 0 {
            title = "Specials"
        }
    
        return title
    }
    
    // MARK: Functions
    
    public func update(status: SickbeardEpisode.SickbeardEpisodeStatus, completion:((NSError?) -> (Void))?) {
        SickbeardService.shared.update(status, forSeason: self, completion: { error in
            if let error = error {
                NSLog("Error while updating episode status: \(error)")
            }
            
            DownDatabase.shared.write {
                self._episodes.forEach({$0.status = status})
            }
            
            if let completion = completion {
                completion(error)
            }
        })
    }
}