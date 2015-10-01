//
//  SickbeardShow.swift
//  Down
//
//  Created by Ruud Puts on 06/09/15.
//  Copyright © 2015 Ruud Puts. All rights reserved.
//

import Foundation
import RealmSwift

public class SickbeardEpisode: Object {
    public dynamic var id = ""
    public dynamic var name = ""
    public dynamic var airDate = ""
    public dynamic var quality = ""
    public dynamic var status = ""
    public dynamic var filename = ""
    
    weak public var season: SickbeardSeason?
    weak public var show: SickbeardShow?
    
    init (_ id: String, _ name: String, _ airDate: String, _ quality: String, _ status: String) {
        self.id = id
        self.name = name
        self.airDate = airDate
        self.quality = quality
        self.status = status
        
        super.init()
    }
    
    public required init() {
        super.init()
    }
    
    public var displayName: String {
        var displayName = name
        if season != nil && show != nil {
            displayName = "\(show!.name) - S\(season!.id)E\(id) - \(name)"
        }
        return displayName
    }
    
}