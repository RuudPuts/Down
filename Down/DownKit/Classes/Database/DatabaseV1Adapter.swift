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
    
    let sickbeardQueue: dispatch_queue_t
    
    init() {
        sickbeardQueue = dispatch_queue_create("Down.DatabaseV1Adapter", nil/*DISPATCH_QUEUE_CONCURRENT*/)
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
        dispatch_async(dispatch_get_main_queue()) {
            database?.write({
                database?.add(show, update: true)
            })
        }
    }
    
    // MARK: Seasons
    
    func storeSickbeardSeason(season: SickbeardSeason) {
        dispatch_async(dispatch_get_main_queue()) {
            database?.write({
                database?.add(season, update: true)
            })
        }
    }
    
    // MARK: Episodes
    
    func storeSickbeardEpisode(episode: SickbeardEpisode) {
        dispatch_async(dispatch_get_main_queue()) {
            database?.write({
                database?.add(episode, update: true)
            })
        }
    }
    
}