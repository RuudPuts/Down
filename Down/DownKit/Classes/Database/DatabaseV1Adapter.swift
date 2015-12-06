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
    
//    let databaseQueue: dispatch_queue_t
    
//    func storeItems(items: [Object], tag: String) {
//        dispatch_async(dispatch_get_main_queue()) {
//            do {
//                try self.database = Realm(path: DatabaseManager.databasePath)
//                
//                NSLog("Starting write to store \(items.count) \(tag)s")
//                do {
//                    try self.database?.write({
//                        for item in items {
//                            self.database?.add(item, update: true)
//                        }
//                    })
//                }
//                catch let error as NSError {
//                    print("Failed to add \(tag): \(error)")
//                }
//                NSLog("Finished write to store \(items.count) \(tag)s")
//            }
//            catch let error as NSError {
//                print("Failed to initialize Realm: \(error)")
//                self.database = nil
//            }
//        }
//    }
    
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
    
}