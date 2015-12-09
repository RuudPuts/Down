//
//  DatabaseManager.swift
//  Down
//
//  Created by Ruud Puts on 23/09/15.
//  Copyright © 2015 Ruud Puts. All rights reserved.
//

import Foundation
import RealmSwift

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
    
    public func fetchAllSickbeardShows() -> [SickbeardShow] {
        return Array(self.adapter.allSickbeardShows())
    }
    
    public func setFilename(filename: String, forEpisode episode: SickbeardEpisode) {
        self.adapter.setFilename(filename, forEpisode: episode)
    }
    
    public func episodeWithFilename(filename: String!) -> SickbeardEpisode? {
        return self.adapter.episodeWithFilename(filename)
    }
    
    public func episodesAiringOnDate(date: NSDate) -> [SickbeardEpisode] {
        return self.adapter.episodesAiringOnDate(date)
    }
    
}