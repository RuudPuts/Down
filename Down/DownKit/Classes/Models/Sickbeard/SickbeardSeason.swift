//
//  SickbeardShow.swift
//  Down
//
//  Created by Ruud Puts on 06/09/15.
//  Copyright © 2015 Ruud Puts. All rights reserved.
//

import Foundation
import RealmSwift

open class SickbeardSeason: Object {
    open dynamic var uniqueId = UUID().uuidString
    open dynamic var id = 0
    internal var _episodes = List<SickbeardEpisode>()
    
    open dynamic weak var show: SickbeardShow?
    
    // Realm
    
    open override static func primaryKey() -> String {
        return "uniqueId"
    }
    
    // Properties
    
    open var episodes: [SickbeardEpisode] {
        let sortedEpisodes = Array(_episodes).sorted {
            $0.id < $1.id
        }
        return sortedEpisodes
    }
    
    open var downloadedEpisodes: [SickbeardEpisode] {
        let filteredEpisodes = Array(_episodes).filter {
            $0.status == .Downloaded
        }
        
        return filteredEpisodes
    }
    
    open var title: String {
        var title = "Season \(id)"
        if id == 0 {
            title = "Specials"
        }
    
        return title
    }
    
    // MARK: Functions
    
    open func update(_ status: SickbeardEpisode.SickbeardEpisodeStatus, completion:((NSError?) -> (Void))?) {
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
