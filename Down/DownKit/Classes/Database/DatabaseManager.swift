//
//  DatabaseManager.swift
//  Down
//
//  Created by Ruud Puts on 23/09/15.
//  Copyright © 2015 Ruud Puts. All rights reserved.
//

import Foundation

public class DatabaseManager {
    
    let _adapter: DatabaseAdapter
    
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
        _adapter = DatabaseV1Adapter()
    }
    
    var adapter: DatabaseV1Adapter {
        return _adapter as! DatabaseV1Adapter
    }
    
    // MARK: Sickbeard
    
    public func storeSickbeardShows(shows: [SickbeardShow]) {
        self.adapter.storeSickbeardShows(shows)
    }
    
    public func storeSickbeardSeasons(seasons: [SickbeardSeason], forShow show: SickbeardShow) {
        self.adapter.storeSickbeardSeasons(seasons, forShow:show)
    }
    
    public func storeSickbeardEpisodes(episodes: [SickbeardEpisode]) {
        self.adapter.storeSickbeardEpisodes(episodes)
    }
    
}