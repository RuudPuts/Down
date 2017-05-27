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
    
    var defaultRealm: Realm {
        get {
            return try! Realm(fileURL: NSURL(fileURLWithPath:DownDatabase.databasePath) as URL)
        }
    }
    
    func write(_ commands: () -> (Void)) {
        let realm = defaultRealm
        do {
            try realm.write(commands)
        }
        catch let error as NSError {
            Log.e("Error while writing to Realm: \(error)")
        }
    }

    // MARK: Shows
    
    func storeSickbeardShows(_ shows: [SickbeardShow]) {
        // Until Realm supports cascading deletion remove the show manually
        shows.forEach {
            deleteSickbeardShow($0)
        }
                
        write {
            shows.forEach {
                self.defaultRealm.add($0, update: true)
            }
        }
    }
    
    func deleteSickbeardShow(_ show: SickbeardShow) {
        guard let showToDelete = sickbeardShowWithIdentifier(show.tvdbId) else {
            return
        }
        
        write {
            self.defaultRealm.delete(showToDelete.allEpisodes)
            self.defaultRealm.delete(showToDelete.seasons)
            self.defaultRealm.delete(showToDelete)
        }
        self.defaultRealm.refresh()
    }
    
    func allSickbeardShows() -> Results<SickbeardShow> {
        let shows = defaultRealm.objects(SickbeardShow.self)
        let sortedShows = shows.sorted(byKeyPath: "name")
        
        return sortedShows
    }
    
    func sickbeardShowWithIdentifier(_ tvdbId: Int) -> SickbeardShow? {
        return self.defaultRealm.objects(SickbeardShow.self).filter("tvdbId == \(tvdbId)").first
    }
    
    // TODO: Also make this return a Results set
    func showsWithEpisodesAiredSince(_ airDate: Date) -> [SickbeardShow] {
        let episodes = episodesAiredSince(airDate)
        
        var shows = [SickbeardShow]()
        for episode in episodes {
            if !shows.contains(episode.show!) {
                shows.append(episode.show!)
            }
        }
        
        return shows
    }
    
    func showBestMatchingComponents(_ components: [String]) -> SickbeardShow? {
        var matchingShows: Results<SickbeardShow>?
        
        for component in components {
            let componentFilter = "_simpleName contains '\(component)'"
            
            var shows: Results<SickbeardShow>?
            if matchingShows == nil {
                shows = defaultRealm.objects(SickbeardShow.self).filter(componentFilter)
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
    
    func setPlot(_ plot: String, forEpisode episode: SickbeardEpisode) {
        guard episode.plot.length == 0 else {
            return
        }
        
        write {
            episode.plot = plot
        }
    }
    
    func episodesAiredSince(_ airDate: Date) -> Results<SickbeardEpisode> {
        let episodes = defaultRealm.objects(SickbeardEpisode.self).filter("airDate >= %@ AND airDate < %@", airDate, Date())
        
        return episodes.sortNewestFirst()
    }
    
    func episodesAiringOnDate(_ date: Date) -> Results<SickbeardEpisode> {
        return defaultRealm.objects(SickbeardEpisode.self)
            .filter("airDate == %@", date.withoutTime())
            .sortOldestFirst()
    }
    
    // TODO: This method might return more than maxEpisodes, since it'll give all shows of the last show's date
    func episodesAiringAfter(_ date: Date, max maxEpisodes: Int) -> Results<SickbeardEpisode> {
        let startDate = date.withoutTime()
        let episodes = defaultRealm.objects(SickbeardEpisode.self).filter("airDate > %@", startDate)
        
        var lastAirDate = Date()
        if episodes.count > maxEpisodes {
            lastAirDate = episodes[maxEpisodes - 1].airDate as Date? ?? lastAirDate
        }
        else if let airDate = episodes.last?.airDate {
            lastAirDate = airDate as Date
        }
        
        return defaultRealm.objects(SickbeardEpisode.self)
            .filter("airDate > %@ AND airDate <= %@", startDate, lastAirDate)
            .sortOldestFirst()
    }
    
}
