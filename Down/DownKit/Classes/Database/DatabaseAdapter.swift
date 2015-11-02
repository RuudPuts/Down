//
//  DatabaseAdapter.swift
//  Down
//
//  Created by Ruud Puts on 23/09/15.
//  Copyright © 2015 Ruud Puts. All rights reserved.
//

import Foundation

protocol DatabaseAdapter {
    
    var version: Int { get }
    
    func createInitialTables()
    
    func storeSickbeardShows(shows: [SickbeardShow])
    func storeSickbeardSeasons(seasons: [SickbeardSeason])
    func storeSickbeardEpisodes(episodes: [SickbeardEpisode])
}