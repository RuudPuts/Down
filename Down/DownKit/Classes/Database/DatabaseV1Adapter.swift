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
    var database: Realm?
    
//    let databaseQueue: dispatch_queue_t
    
    init() {
    }
    
    func createInitialTables() {
    }
    
    func storeItems(items: [Object], tag: String) {
        dispatch_async(dispatch_get_main_queue()) {
            do {
                try self.database = Realm(path: DatabaseManager.databasePath)
                print("Loaded database at path \(DatabaseManager.databasePath)")
                
                NSLog("Starting write to store \(items.count) \(tag)s")
                do {
                    try self.database?.write({
                        for item in items {
                            self.database?.add(item, update: true)
                        }
                    })
                }
                catch let error as NSError {
                    print("Failed to add \(tag): \(error)")
                }
                NSLog("Finished write to store \(items.count) \(tag)s")
            }
            catch let error as NSError {
                print("Failed to initialize Realm: \(error)")
                self.database = nil
            }
        }
    }
    
    // MARK: Shows
    
    func storeSickbeardShows(shows: [SickbeardShow]) {
        dispatch_async(dispatch_get_main_queue()) {
            do {
                try self.database = Realm(path: DatabaseManager.databasePath)
                print("Loaded database at path \(DatabaseManager.databasePath)")
                
                NSLog("Starting write to store \(shows.count) shows")
                do {
                    try self.database?.write({
                        for show in shows {
                            self.database?.add(show, update: true)
                        }
                    })
                }
                catch let error as NSError {
                    print("Failed to add show: \(error)")
                }
                NSLog("Finished write to store \(shows.count) shows")
            }
            catch let error as NSError {
                print("Failed to initialize Realm: \(error)")
                self.database = nil
            }
        }
    }
    
    // MARK: Seasons
    
    func storeSickbeardSeasons(seasons: [SickbeardSeason], forShow show: SickbeardShow) {
        dispatch_async(dispatch_get_main_queue()) {
            do {
                try self.database = Realm(path: DatabaseManager.databasePath)
                print("Loaded database at path \(DatabaseManager.databasePath)")
                
                NSLog("Starting write to store \(seasons.count) seasons for \(show.name)")
                do {
                    try self.database?.write({
                        for season in seasons {
//                            show.addSeason(season)
                            self.database?.add(season, update: true)
                        }
                    })
                }
                catch let error as NSError {
                    print("Failed to add season: \(error)")
                }
                NSLog("Finished write to store \(seasons.count) seasons")
            }
            catch let error as NSError {
                print("Failed to initialize Realm: \(error)")
                self.database = nil
            }
        }
    }
    
    // MARK: Episodes
    
    func storeSickbeardEpisodes(episodes: [SickbeardEpisode]) {
        storeItems(episodes, tag: "episode")
    }
    
}