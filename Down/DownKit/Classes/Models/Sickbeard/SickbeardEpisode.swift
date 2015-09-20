//
//  SickbeardShow.swift
//  Down
//
//  Created by Ruud Puts on 06/09/15.
//  Copyright © 2015 Ruud Puts. All rights reserved.
//

import Foundation

public class SickbeardEpisode {
    public var id: String!
    public var name: String!
    public let airDate: String!
    public var quality: String!
    public var status: String!
    public var filename: String?
    
    weak public var season: SickbeardSeason?
    weak public var show: SickbeardShow?
    
    init (_ id: String, _ name: String, _ airDate: String, _ quality: String, _ status: String) {
        self.id = id
        self.name = name
        self.airDate = airDate
        self.quality = quality
        self.status = status
    }
    
    public var displayName: String! {
        return String(format: "%@ - S%02dE%02d", name, (season?.id)!, id)
    }
    
}