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
        return try! Realm(fileURL: NSURL(fileURLWithPath:DatabaseManager.databasePath))
    }

    // MARK: Shows
    
    func storeSickbeardShows(shows: [SickbeardShow]) {
        // Until Realm supports cascading deletion remove the show manually
        shows.forEach {
            deleteSickbeardShow($0)
        }
        
        let realm = defaultRealm()
        try! realm.write {
            shows.forEach {
                realm.add($0, update: false)
            }
        }
    }
    
    func deleteSickbeardShow(show: SickbeardShow) {
        guard let showToDelete = sickbeardShowWithIdentifier(show.tvdbId) else {
            return
        }
        
        let realm = defaultRealm()
        try! realm.write {
            realm.delete(showToDelete.allEpisodes)
            realm.delete(showToDelete.seasons)
            realm.delete(showToDelete)
        }
    }
    
    func allSickbeardShows() -> Results<SickbeardShow> {
        let realm = defaultRealm()
        let shows = realm.objects(SickbeardShow)
        let sortedShows = shows.sorted("name")
        
        return sortedShows
    }
    
    func sickbeardShowWithIdentifier(tvdbId: Int) -> SickbeardShow? {
        return defaultRealm().objects(SickbeardShow).filter("tvdbId == \(tvdbId)").first
    }
    
    // TODO: Also make this return a Results set
    func showsWithEpisodesAiredSince(airDate: NSDate) -> [SickbeardShow] {
        let episodes = episodesAiredSince(airDate)
        
        var shows = [SickbeardShow]()
        for episode in episodes {
            if !shows.contains(episode.show!) {
                shows.append(episode.show!)
            }
        }
        
        return shows
    }
    
    func showBestMatchingComponents(components: [String]) -> SickbeardShow? {
        var matchingShows: Results<SickbeardShow>?
        
        let realm = defaultRealm()
        for component in components {
            let componentFilter = "_simpleName contains '\(component)'"
            
            var shows: Results<SickbeardShow>?
            if matchingShows == nil {
                shows = realm.objects(SickbeardShow).filter(componentFilter)
            }
            else {
                shows = matchingShows?.filter(componentFilter)
            }
            
            guard shows!.count > 0 else {
                return matchingShows?.first
            }
            
            matchingShows = shows
        }

        return matchingShows?.first
    }
    
    func setPlot(plot: String, forEpisode episode: SickbeardEpisode) {
        guard episode.plot.length == 0 else {
            return
        }
        
        let realm = defaultRealm()
        try! realm.write {
            episode.plot = plot
            NSLog("Stored plot for (\(episode.show!.name) S\(episode.season!.id)E\(episode.id))")
        }
    }
    
    func episodesAiredSince(airDate: NSDate) -> Results<SickbeardEpisode> {
        let realm = defaultRealm()
        let episodes = realm.objects(SickbeardEpisode).filter("airDate >= %@ AND airDate < %@", airDate, NSDate())
        
        return episodes.sortNewestFirst()
    }
    
    func episodesAiringOnDate(date: NSDate) -> Results<SickbeardEpisode> {
        let calendar = NSCalendar.currentCalendar()
        let dateComponents = calendar.components([NSCalendarUnit.Year, NSCalendarUnit.Month, NSCalendarUnit.Day], fromDate: date)
        let episodes = defaultRealm().objects(SickbeardEpisode)
            .filter("airDate == %@", calendar.dateFromComponents(dateComponents)!)
            .sortOldestFirst()
        
        return episodes
    }
    
    // TODO: This method might return more than maxEpisodes, since it'll give all shows of the last show's date
    func episodesAiringAfter(date: NSDate, max maxEpisodes: Int) -> Results<SickbeardEpisode> {
        let realm = defaultRealm()
        
        let startDate = date.dateWithoutTime()
        let episodes = realm.objects(SickbeardEpisode).filter("airDate > %@", startDate)
        
        var lastAirDate = NSDate()
        if episodes.count > maxEpisodes {
            lastAirDate = episodes[maxEpisodes - 1].airDate ?? lastAirDate
        }
        else if let airDate = episodes.last?.airDate {
            lastAirDate = airDate
        }
        
        return realm.objects(SickbeardEpisode)
            .filter("airDate > %@ AND airDate <= %@", startDate, lastAirDate)
            .sortOldestFirst()
    }
    
}