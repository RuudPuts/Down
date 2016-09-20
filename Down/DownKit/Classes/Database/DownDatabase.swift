//
//  DownDatabase.swift
//  Down
//
//  Created by Ruud Puts on 23/09/15.
//  Copyright © 2015 Ruud Puts. All rights reserved.
//

import Foundation
import RealmSwift

public class DownDatabase: DownCache {
    
    public static let shared = DownDatabase()
    
    let adapter = DatabaseV1Adapter()
    
    static let DatabaseFile = "down.realm"
    
    class var databasePath: String {
        let storageDirectory = "\(UIApplication.documentsDirectory)"
        do {
            try NSFileManager.defaultManager().createDirectoryAtPath(storageDirectory, withIntermediateDirectories: true, attributes: nil)
        }
        catch let error as NSError {
            print("Error while creating databasePath: \(error)")
        }
        return storageDirectory + "/" + DatabaseFile
    }
    
    class var databaseExists: Bool {
        return NSFileManager.defaultManager().fileExistsAtPath(databasePath)
    }
    
    public init() {
        NSLog("DatabasePath: \(DownDatabase.databasePath)")
    }
    
    public func write(commands: () -> (Void)) {
        self.adapter.write(commands)
    }
    
    public static func clearCache() {
        let storageDirectory = UIApplication.documentsDirectory
        
        do {
            let allFiles = try NSFileManager.defaultManager().contentsOfDirectoryAtPath(storageDirectory)
            
            for file in allFiles {
                if !file.hasPrefix(DatabaseFile) {
                    continue
                }
                
                let filePath = storageDirectory + "/" + file
                try NSFileManager.defaultManager().removeItemAtPath(filePath)
            }
        }
        catch let error as NSError {
            print("Error while clearing DownDatabase: \(error)")
        }
    }
    
    // MARK: Sickbeard
    
    public func storeSickbeardShows(shows: [SickbeardShow]) {
        self.adapter.storeSickbeardShows(shows)
    }
    
    public func deleteSickbeardShow(show: SickbeardShow) {
        self.adapter.deleteSickbeardShow(show)
    }
    
    public func fetchAllSickbeardShows() -> Results<SickbeardShow> {
        return self.adapter.allSickbeardShows()
    }
    
    public func fetchShowsWithEpisodesAiredSince(airDate: NSDate) -> [SickbeardShow] {
        return self.adapter.showsWithEpisodesAiredSince(airDate)
    }
    
    public func setPlot(plot: String, forEpisode episode: SickbeardEpisode) {
        self.adapter.setPlot(plot, forEpisode: episode)
    }
    
    public func episodesAiringOnDate(date: NSDate) -> Results<SickbeardEpisode> {
        return self.adapter.episodesAiringOnDate(date)
    }
    
    public func episodesAiringAfter(date: NSDate, max maxEpisodes: Int) -> Results<SickbeardEpisode> {
        return self.adapter.episodesAiringAfter(date, max: maxEpisodes)
    }
    
    public func lastAiredEpisodes(maxDays maxDays: Int) -> Results<SickbeardEpisode> {
        let today = NSDate().dateWithoutTime()
        let daysAgo = today.dateByAddingTimeInterval(-(86400 * Double(maxDays)))
        
        return self.adapter.episodesAiredSince(daysAgo)
    }
    
    public func showBestMatchingComponents(components: [String]) -> SickbeardShow? {
        return self.adapter.showBestMatchingComponents(components)
    }
    
}