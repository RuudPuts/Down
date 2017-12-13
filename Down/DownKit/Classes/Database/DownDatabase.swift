//
//  DownDatabase.swift
//  Down
//
//  Created by Ruud Puts on 23/09/15.
//  Copyright © 2015 Ruud Puts. All rights reserved.
//

import UIKit
import RealmSwift

public class DownDatabase: DownCache {
    
    public static let shared = DownDatabase()
    
    let adapter: DatabaseAdapter = DatabaseV1Adapter()
    
    static let DatabaseFile = "down.realm"
    
    class var databasePath: String {
        let storageDirectory = "\(UIApplication.documentsDirectory)"
        do {
            try FileManager.default.createDirectory(atPath: storageDirectory,
                                                    withIntermediateDirectories: true,
                                                    attributes: nil)
        }
        catch {
            Log.e("Error while creating databasePath: \(error)")
        }
        return storageDirectory + "/" + DatabaseFile
    }
    
    class var databaseExists: Bool {
        return FileManager.default.fileExists(atPath: databasePath)
    }
    
    public init() {
        Log.d("DatabasePath: \(DownDatabase.databasePath)")
    }
    
    public func write(_ commands: () -> Void) {
        self.adapter.write(commands)
    }
    
    public static func clearCache() {
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
        catch {
            Log.e("Error while clearing DownDatabase: \(error)")
        }
    }
    
    // MARK: Sickbeard
    
    public func storeSickbeardShow(_ show: SickbeardShow) {
        self.adapter.storeSickbeardShows([show])
    }
    
    public func storeSickbeardShows(_ shows: [SickbeardShow]) {
        self.adapter.storeSickbeardShows(shows)
    }
    
    public func deleteSickbeardShow(_ show: SickbeardShow) {
        self.adapter.deleteSickbeardShow(show)
    }
    
    public func fetchAllSickbeardShows() -> Results<SickbeardShow> {
        return self.adapter.allSickbeardShows()
    }
    
    public func fetchContinuingShows() -> Results<SickbeardShow> {
        return self.adapter.fetchContinuingShows()
    }
    
    public func setPlot(_ plot: String, forEpisode episode: SickbeardEpisode) {
        self.adapter.setPlot(plot, forEpisode: episode)
    }
    
    public func episodesAiringOnDate(_ date: Date) -> Results<SickbeardEpisode> {
        return self.adapter.episodesAiringOnDate(date)
    }
    
    public func episodesAiringAfter(_ date: Date, max maxEpisodes: Int) -> Results<SickbeardEpisode> {
        return self.adapter.episodesAiringAfter(date, max: maxEpisodes)
    }
    
    public func lastAiredEpisodes(maxDays: Int) -> Results<SickbeardEpisode> {
        let today = Date().withoutTime()
        let daysAgo = today.addingTimeInterval(-(86400 * Double(maxDays)))
        
        return self.adapter.episodesAiredSince(daysAgo)
    }
    
    public func showBestMatchingComponents(_ components: [String]) -> SickbeardShow? {
        return self.adapter.showBestMatchingComponents(components)
    }
    
}
