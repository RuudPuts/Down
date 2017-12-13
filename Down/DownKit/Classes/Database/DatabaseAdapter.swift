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
    
    func write(_ commands: () -> Void)
    
    func storeSickbeardShows(_ shows: [SickbeardShow])
    func deleteSickbeardShow(_ show: SickbeardShow)
    
    func allSickbeardShows() -> Results<SickbeardShow>
    func fetchContinuingShows() -> Results<SickbeardShow>
    func showBestMatchingComponents(_ components: [String]) -> SickbeardShow?
    
    func setPlot(_ plot: String, forEpisode episode: SickbeardEpisode)
    
    func episodesAiringOnDate(_ date: Date) -> Results<SickbeardEpisode>
    func episodesAiredSince(_ airDate: Date) -> Results<SickbeardEpisode>
    func episodesAiringAfter(_ date: Date, max maxEpisodes: Int) -> Results<SickbeardEpisode>
}
