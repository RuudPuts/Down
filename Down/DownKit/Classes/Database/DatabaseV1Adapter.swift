//
//  DatabaseV1Adapter.swift
//  Down
//
//  Created by Ruud Puts on 23/09/15.
//  Copyright © 2015 Ruud Puts. All rights reserved.
//

import Foundation
import Squeal

class DatabaseV1Adapter: DatabaseAdapter {
    
    var version = 1
    var database: Database?
    
    enum SickbeardShowData: String {
        case ShowsTable = "shows"
        case TvdbidColumn = "tvdbid"
        case NameColumn = "name"
        case StatusColumn = "status"
    }
    
    init() {
        do {
            print("DatabasePath: \(DatabaseManager.databasePath)")
            database = try Database(path: DatabaseManager.databasePath)
        }
        catch let error as NSError {
            print("An error occured while accessing database, no point in continuing\n\(error)");
        }
        
        createInitialTables()
    }
    
    func createInitialTables() {
        createShowsTable()
        createSeasonsTable()
        createEpisodesTable()
//        database!.updateUserVersionNumber(version)
    }
    
    // MARK: Shows
    
    func createShowsTable() {
        do {
            try database!.createTable("shows",
                definitions:[
                    "tvdbid INTEGER PRIMARY KEY",
                    "name TEXT NOT NULL",
                    "status TEXT NOT NULL"
                ],
                ifNotExists:true)
        }
        catch let error as NSError {
            print("Error while creating shows table: \(error)")
        }
    }
    
    func hasDataForShow(show: SickbeardShow) -> Bool {
        var hasData = false
        
        do {
            let shows = try database!.selectFrom("shows", whereExpr:"tvdbid = \(show.tvdbId)") { $0 }
            hasData = shows.count > 0
        }
        catch let error as NSError {
            print("Error while checking show data: \(error)")
        }
        
        return hasData
    }
    
    func storeSickbeardShow(show: SickbeardShow) {
        if hasDataForShow(show) {
            updateSickbeardShow(show)
        }
        else {
            insertSickbeardShow(show)
        }
    }
    
    func insertSickbeardShow(show: SickbeardShow) {
        do {
            try database!.insertInto("shows", values: [
                "tvdbid": show.tvdbId,
                "name": show.name,
                "status": show.status.rawValue])
        }
        catch let error as NSError {
            print("Error while inserting show \(show.name): \(error)")
        }
    }
    
    func updateSickbeardShow(show: SickbeardShow) {
        do {
            try database!.update("shows", columns: ["status"], values: [show.status.rawValue], whereExpr: "tvdbid = ?", parameters: [show.tvdbId])
        }
        catch let error as NSError {
            print("Error while updating show \(show.name): \(error)")
        }
    }
    
    // MARK: Seasons
    
    func createSeasonsTable() {
        do {
            try database!.createTable("seasons",
                definitions:[
                    "id INTEGER PRIMARY KEY",
                    "seasonId INTEGER NOT NULL",
                    "showId TEXT NOT NULL"
                ],
                ifNotExists:true)
        }
        catch let error as NSError {
            print("Error while creating seasons table: \(error)")
        }
    }
    
    func hasDataForSeason(season: SickbeardSeason) -> Bool {
        var hasData = false
        
        if let show = season.show {
            do {
                let seasons = try database!.selectFrom("seasons", whereExpr:"showId = \(show.tvdbId) and seasonId = \(season.id)") { $0 }
                hasData = seasons.count > 0
            }
            catch let error as NSError {
                print("Error while checking season data: \(error)")
            }
        }
        
        return hasData
    }
    
    func storeSickbeardSeason(season: SickbeardSeason) {
        if !hasDataForSeason(season) {
            insertSickbeardSeason(season)
        }
    }
    
    func insertSickbeardSeason(season: SickbeardSeason) {
        do {
            try database!.insertInto("seasons", values: [
                "seasonId": season.id,
                "showId": season.show?.tvdbId])
        }
        catch let error as NSError {
            print("Error while storing season \(season.id) for show \(season.show?.name): \(error)")
        }
    }
    
    // MARK: Episodes
    
    func createEpisodesTable() {
        do {
            try database!.createTable("episodes",
                definitions:[
                    "id INTEGER PRIMARY KEY",
                    "episodeId TEXT NOT NULL",
                    "seasonId TEXT NOT NULL",
                    "showId TEXT NOT NULL",
                    "name TEXT NOT NULL",
                    "airDate TEXT NOT NULL",
                    "quality TEXT NOT NULL",
                    "status TEXT NOT NULL",
                    "filename TEXT"
                ],
                ifNotExists:true)
        }
        catch let error as NSError {
            print("Error while creating episodes table: \(error)")
        }
    }
    
    func hasDataForEpisode(episode: SickbeardEpisode) -> Bool {
        var hasData = false
        
        if let show = episode.show {
            if  let season = episode.season {
                do {
                    let episodes = try database!.selectFrom("episodes", whereExpr:"showId = \(show.tvdbId)" +
                        " and seasonId = \(season.id) and episodeId = \(episode.id)") { $0 }
                    hasData = episodes.count > 0
                }
                catch let error as NSError {
                    print("Error while checking episode data: \(error)")
                }
            }
        }
        
        return hasData
    }
    
    func storeSickbeardEpisode(episode: SickbeardEpisode) {
        if hasDataForEpisode(episode) {
            updateSickbeardEpisode(episode)
        }
        else {
            insertSickbeardEpisode(episode)
        }
    }
    
    private func insertSickbeardEpisode(episode: SickbeardEpisode) {
        do {
            try database!.insertInto("episodes", values: [
                "episodeId": episode.id,
                "seasonId": episode.season?.id,
                "showId": episode.show?.tvdbId,
                "name": episode.name,
                "airDate": episode.airDate,
                "quality": episode.quality,
                "status": episode.status,
                "filename": episode.filename])
        }
        catch let error as NSError {
            print("Error while storing episode S\(episode.season?.id)E\(episode.id) for show \(episode.show?.name): \(error)")
        }
    }
    
    private func updateSickbeardEpisode(episode: SickbeardEpisode) {
        do {
            if let show = episode.show {
                if  let season = episode.season {
                    try database!.update("episodes", columns: ["name", "airDate", "quality", "status", "filename"],
                        values: [episode.name, episode.airDate, episode.quality, episode.status, episode.filename],
                        whereExpr: "showId = ? and seasonId = ? and episodeId = ?", parameters: [show.tvdbId, season.id, episode.id])
                }
            }
        }
        catch let error as NSError {
            print("Error while updating episode S\(episode.season?.id)E\(episode.id) for show \(episode.show?.name): \(error)")
        }
    }
    
}