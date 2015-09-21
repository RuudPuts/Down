//
//  SickbeardShow.swift
//  Down
//
//  Created by Ruud Puts on 06/09/15.
//  Copyright © 2015 Ruud Puts. All rights reserved.
//

import Foundation

public class SickbeardSeason {
    public var id: String!
    public var episodes = [SickbeardEpisode]()
    
    weak public var show: SickbeardShow?
    
    public enum SickbeardShowStatus {
        case Stopped
        case Active
    }
    
    init (id: String) {
        self.id = id
    }
    
    internal func addEpisode(episode: SickbeardEpisode) {
        episodes.append(episode)
        episode.season = self
        episode.show = show
    }
    
}