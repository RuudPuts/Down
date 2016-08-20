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
        let storageDirectory = "\(UIApplication.documentsDirectory)"
        do {
            try NSFileManager.defaultManager().createDirectoryAtPath(storageDirectory, withIntermediateDirectories: true, attributes: nil)
        }
        catch let error as NSError {
            print("Error while creating databasePath: \(error)")
        }
        return storageDirectory + "/down.realm"
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
    
    public func setStatus(status: SickbeardShow.SickbeardShowStatus, forShow show: SickbeardShow) {
        adapter.setStatus(status, forShow:show)
    }
    
    public func fetchAllSickbeardShows() -> [SickbeardShow] {
        return Array(self.adapter.allSickbeardShows())
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