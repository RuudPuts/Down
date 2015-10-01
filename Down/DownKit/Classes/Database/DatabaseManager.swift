//
//  DatabaseManager.swift
//  Down
//
//  Created by Ruud Puts on 23/09/15.
//  Copyright © 2015 Ruud Puts. All rights reserved.
//

import Foundation

public class DatabaseManager {
    
    let adapter: DatabaseAdapter
    
    class var databasePath: String {
        let sickbeardDirectory = "\(UIApplication.documentsDirectory)/sickbeard"
        do {
            try NSFileManager.defaultManager().createDirectoryAtPath(sickbeardDirectory, withIntermediateDirectories: true, attributes: nil)
        }
        catch let error as NSError {
            print("Error while creating databasePath: \(error)")
        }
        return sickbeardDirectory + "/sickbeard.realm"
    }
    
    class var databaseExists: Bool {
        return NSFileManager.defaultManager().fileExistsAtPath(databasePath)
    }
    
    public init() {
        adapter = DatabaseV1Adapter()
    }
    
    // MARK: Sickbeard
    
    public func storeSickbeardShow(show: SickbeardShow) {
        NSLog("Storing show \(show.name)")
        self.adapter.storeSickbeardShow(show)
//        for season in show.seasons {
//            NSLog("Storing season \(season.id)")
//            self.adapter.storeSickbeardSeason(season)
//            for episode in season.episodes {
//                self.adapter.storeSickbeardEpisode(episode)
//            }
//        }
        NSLog("Finished show \(show.name)")
    }
    
    public func storeSickbeardEpisode(episode: SickbeardEpisode) {
        self.adapter.storeSickbeardEpisode(episode)
    }
    
}