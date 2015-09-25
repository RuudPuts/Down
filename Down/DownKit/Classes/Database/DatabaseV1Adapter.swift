//
//  DatabaseV1Adapter.swift
//  Down
//
//  Created by Ruud Puts on 23/09/15.
//  Copyright © 2015 Ruud Puts. All rights reserved.
//

import Foundation
import Squeal

class DatabaseV1Adapter: DatabaseAdapter {
    
    var version = 1
    var database: Database?
    
    enum SickbeardShowData: String {
        case ShowsTable = "shows"
        case TvdbidColumn = "tvdbid"
        case NameColumn = "name"
        case StatusColumn = "status"
    }
    
    init() {
        do {
            try NSFileManager.defaultManager().removeItemAtPath(DatabaseManager.databasePath)
        }
        catch {
            
        }
        
        do {
            database = try Database(path: DatabaseManager.databasePath)
        }
        catch let error as NSError {
            print("An error occured while accessing database, no point in continuing\n\(error)");
        }
        
        createInitialTables()
    }
    
    func createInitialTables() {
        createShowsTable()
//        database!.updateUserVersionNumber(version)
    }
    
    func createShowsTable() {
        do {
            try database!.createTable("shows",
                definitions:[
                    "tvdbid INTEGER PRIMARY KEY",
                    "name TEXT NOT NULL",
                    "status TEXT NOT NULL"
                ],
                ifNotExists:true)
        }
        catch let error as NSError {
            print("Error while creating shows table: \(error)")
        }
    }
    
    func storeSickbeardShow(show: SickbeardShow) {
        do {
            try database!.insertInto("shows", values: [
                "tvdbid": show.tvdbId,
                "name": show.name,
                "status": show.status.rawValue])
        }
        catch let error as NSError {
            print("Error while storing show \(show.name): \(error)")
        }
    }
    
}