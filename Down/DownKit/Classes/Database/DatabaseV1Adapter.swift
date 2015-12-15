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
    
    func defaultRealm() -> Realm {
        return try! Realm(path: DatabaseManager.databasePath)
    }

    // MARK: Shows
    
    func storeSickbeardShows(shows: [SickbeardShow]) {
        let realm = defaultRealm()
        try! realm.write({
            for show in shows {
                realm.add(show, update: true)
                NSLog("Stored show \(show.name) (\(show.seasons.count) seasons)")
            }
        })
    }
    
    func allSickbeardShows() -> Results<SickbeardShow> {
        let realm = defaultRealm()
        let shows = realm.objects(SickbeardShow)
        let sortedShows = shows.sorted("name")
        
        return sortedShows
    }
    
    func setFilename(filename: String, forEpisode episode: SickbeardEpisode) {
        let realm = defaultRealm()
        try! realm.write({
            if !episode.filename.containsString(filename) {
                episode.filename = filename
            }
        })
    }
    
    func episodeWithFilename(filename: String!) -> SickbeardEpisode? {
        let predicate = NSPredicate(format: "filename BEGINSWITH %@", filename)
        let episode = defaultRealm().objects(SickbeardEpisode).filter(predicate).first
        
        return episode
    }
    
    func episodesAiringOnDate(date: NSDate) -> [SickbeardEpisode] {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        
        let dateString = dateFormatter.stringFromDate(date)
        let predicate = NSPredicate(format: "airDate = %@", dateString)
        // TODO: Sort the episodes on first airing
        let episodes = Array(defaultRealm().objects(SickbeardEpisode).filter(predicate))
        
        return episodes
    }
    
}