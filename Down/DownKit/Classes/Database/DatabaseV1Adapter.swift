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
    
    func setStatus(status: SickbeardShow.SickbeardShowStatus, forShow show: SickbeardShow) {
        let realm = defaultRealm()
        try! realm.write({
            show.status = status
        })
    }
    
    func setFilename(filename: String, forEpisode episode: SickbeardEpisode) {
        let realm = defaultRealm()
        try! realm.write({
            // WARN: this if-statement seems to result in false positives?
            if !episode.filename.containsString(filename) && episode.filename != filename {
                episode.filename = filename
                NSLog("Stored filename for (\(episode.show!.name) S\(episode.season!.id)E\(episode.id))")
            }
        })
    }
    
    func setPlot(plot: String, forEpisode episode: SickbeardEpisode) {
        let realm = defaultRealm()
        try! realm.write({
            episode.plot = plot
            NSLog("Stored plot for (\(episode.show!.name) S\(episode.season!.id)E\(episode.id))")
        })
    }
    
    func episodeWithFilename(filename: String!) -> SickbeardEpisode? {
        let predicate = NSPredicate(format: "filename BEGINSWITH %@", filename)
        let episode = defaultRealm().objects(SickbeardEpisode).filter(predicate).first
        
        return episode
    }
    
    func episodesAiringOnDate(date: NSDate) -> [SickbeardEpisode] {
        // TODO: Sort the episodes on first airing
        let calendar = NSCalendar.currentCalendar()
        let dateComponents = calendar.components([NSCalendarUnit.Year, NSCalendarUnit.Month, NSCalendarUnit.Day], fromDate: date)
        let episodes = Array(defaultRealm().objects(SickbeardEpisode).filter("airDate == %@", calendar.dateFromComponents(dateComponents)!))
        
        return episodes
    }
    
    func episodesAiredSince(airDate: NSDate) -> [SickbeardShow] {
        let realm = defaultRealm()
        let episodes = realm.objects(SickbeardEpisode).filter("airDate > %@ AND airDate < %@", airDate, NSDate())
        
        var shows = [SickbeardShow]()
        for episode in episodes {
            if !shows.contains(episode.show!) {
                shows.append(episode.show!)
            }
        }
        
        return shows
    }
    
}