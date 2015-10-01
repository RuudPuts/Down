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
    let database: Realm?
    
    init() {
        do {
            try database = Realm(path: DatabaseManager.databasePath)
            print("Loaded database at path \(DatabaseManager.databasePath)")
        }
        catch let error as NSError {
            print("Failed to initialize Realm: \(error)")
            database = nil
        }
    }
    
    func createInitialTables() {
    }
    
    // MARK: Shows
    
    func storeSickbeardShow(show: SickbeardShow) {
        database?.write({
            database?.add(show, update: true)
        })
    }
    
    // MARK: Seasons
    
    func storeSickbeardSeason(season: SickbeardSeason) {
        database?.write({
            database?.add(season, update: true)
        })
    }
    
    // MARK: Episodes
    
    func storeSickbeardEpisode(episode: SickbeardEpisode) {
        database?.write({
            database?.add(episode, update: true)
        })
    }
    
}