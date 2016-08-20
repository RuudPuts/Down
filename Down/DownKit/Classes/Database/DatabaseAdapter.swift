//
//  DatabaseAdapter.swift
//  Down
//
//  Created by Ruud Puts on 23/09/15.
//  Copyright © 2015 Ruud Puts. All rights reserved.
//

import Foundation
import RealmSwift

protocol DatabaseAdapter {
    
    var version: Int { get }
    
    func storeSickbeardShows(shows: [SickbeardShow])
    func setStatus(status: SickbeardShow.SickbeardShowStatus, forShow show: SickbeardShow)
    
    func allSickbeardShows() -> Results<SickbeardShow>
    func showsWithEpisodesAiredSince(airDate: NSDate) -> [SickbeardShow]
    func showBestMatchingComponents(components: [String]) -> SickbeardShow?
    
    func setPlot(plot: String, forEpisode episode: SickbeardEpisode)
    
    func episodesAiringOnDate(date: NSDate) -> Results<SickbeardEpisode>
    func episodesAiredSince(airDate: NSDate) -> Results<SickbeardEpisode>
    func episodesAiringAfter(date: NSDate, max maxEpisodes: Int) -> Results<SickbeardEpisode>
}