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
    func allSickbeardShows() -> Results<SickbeardShow>
    
    func setFilename(filename: String, forEpisode episode: SickbeardEpisode)
    func episodeWithFilename(filename: String!) -> SickbeardEpisode?
}