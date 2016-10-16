//
//  DownDatabase.swift
//  Down
//
//  Created by Ruud Puts on 23/09/15.
//  Copyright © 2015 Ruud Puts. All rights reserved.
//

import Foundation
import RealmSwift

open class DownDatabase: DownCache {
    
    open static let shared = DownDatabase()
    
    let adapter = DatabaseV1Adapter()
    
    static let DatabaseFile = "down.realm"
    
    class var databasePath: String {
        let storageDirectory = "\(UIApplication.documentsDirectory)"
        do {
            try FileManager.default.createDirectory(atPath: storageDirectory, withIntermediateDirectories: true, attributes: nil)
        }
        catch let error as NSError {
            print("Error while creating databasePath: \(error)")
        }
        return storageDirectory + "/" + DatabaseFile
    }
    
    class var databaseExists: Bool {
        return FileManager.default.fileExists(atPath: databasePath)
    }
    
    public init() {
        NSLog("DatabasePath: \(DownDatabase.databasePath)")
    }
    
    open func write(_ commands: () -> (Void)) {
        self.adapter.write(commands)
    }
    
    open static func clearCache() {
        let storageDirectory = UIApplication.documentsDirectory
        
        do {
            let allFiles = try FileManager.default.contentsOfDirectory(atPath: storageDirectory)
            
            for file in allFiles {
                if !file.hasPrefix(DatabaseFile) {
                    continue
                }
                
                let filePath = storageDirectory + "/" + file
                try FileManager.default.removeItem(atPath: filePath)
            }
        }
        catch let error as NSError {
            print("Error while clearing DownDatabase: \(error)")
        }
    }
    
    // MARK: Sickbeard
    
    open func storeSickbeardShows(_ shows: [SickbeardShow]) {
        self.adapter.storeSickbeardShows(shows)
    }
    
    open func deleteSickbeardShow(_ show: SickbeardShow) {
        self.adapter.deleteSickbeardShow(show)
    }
    
    open func fetchAllSickbeardShows() -> Results<SickbeardShow> {
        return self.adapter.allSickbeardShows()
    }
    
    open func fetchShowsWithEpisodesAiredSince(_ airDate: Date) -> [SickbeardShow] {
        return self.adapter.showsWithEpisodesAiredSince(airDate)
    }
    
    open func setPlot(_ plot: String, forEpisode episode: SickbeardEpisode) {
        self.adapter.setPlot(plot, forEpisode: episode)
    }
    
    open func episodesAiringOnDate(_ date: Date) -> Results<SickbeardEpisode> {
        return self.adapter.episodesAiringOnDate(date)
    }
    
    open func episodesAiringAfter(_ date: Date, max maxEpisodes: Int) -> Results<SickbeardEpisode> {
        return self.adapter.episodesAiringAfter(date, max: maxEpisodes)
    }
    
    open func lastAiredEpisodes(maxDays: Int) -> Results<SickbeardEpisode> {
        let today = Date().withoutTime()
        let daysAgo = today.addingTimeInterval(-(86400 * Double(maxDays)))
        
        return self.adapter.episodesAiredSince(daysAgo)
    }
    
    open func showBestMatchingComponents(_ components: [String]) -> SickbeardShow? {
        return self.adapter.showBestMatchingComponents(components)
    }
    
}
