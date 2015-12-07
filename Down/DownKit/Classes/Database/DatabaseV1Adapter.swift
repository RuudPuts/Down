//
//  DatabaseV1Adapter.swift
//  Down
//
//  Created by Ruud Puts on 23/09/15.
//  Copyright © 2015 Ruud Puts. All rights reserved.
//

import Foundation
import RealmSwift

class DatabaseV1Adapter: DatabaseAdapter {
    
    var version = 1
    var realm: Realm
//    var database: Realm?
    
    init() {
        realm = try! Realm(path: DatabaseManager.databasePath)
    }

    // MARK: Shows
    
    func storeSickbeardShows(shows: [SickbeardShow]) {
        try! realm.write({
            for show in shows {
                self.realm.add(show, update: true)
                NSLog("Stored show \(show.name) (\(show.seasons.count) seasons)")
            }
        })
    }
    
    func allSickbeardShows() -> Results<SickbeardShow> {
        return realm.objects(SickbeardShow)
    }
    
    func setFilename(filename: String, forEpisode episode: SickbeardEpisode) {
        try! realm.write({
            if !episode.filename.containsString(filename) {
                episode.filename = filename
            }
        })
    }
    
    func episodeWithFilename(filename: String!) -> SickbeardEpisode? {
        let predicate = NSPredicate(format: "filename BEGINSWITH %@", filename)
        let episode = realm.objects(SickbeardEpisode).filter(predicate).first
        
        return episode
    }
    
}