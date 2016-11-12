//
//  DownApplication+Extensions.swift
//  Down
//
//  Created by Ruud Puts on 12/11/16.
//  Copyright © 2016 Ruud Puts. All rights reserved.
//

import DownKit

extension DownApplication {
    var color: UIColor {
        switch self {
        case .Down: return UIColor.downRedColor()
            
        case .SabNZBd: return .downSabNZBdColor()
        case .Sickbeard: return .downSickbeardColor()
        case .CouchPotato: return .downCouchPotatoColor()
        }
    }
    
    var darkColor: UIColor {
        switch self {
        case .Down: return UIColor.downRedColor()
            
        case .SabNZBd: return .downSabNZBdDarkColor()
        case .Sickbeard: return .downSickbeardDarkColor()
        case .CouchPotato: return .downCouchPotatoDarkColor()
        }
    }
    
    var icon: UIImage? {
        switch self {
        case .Down: return UIImage(named: "down-icon")
            
        case .SabNZBd: return UIImage(named: "sabnzbd-icon")
        case .Sickbeard: return UIImage(named: "sickbeard-icon")
        case .CouchPotato: return UIImage(named: "couchpotato-icon")
        }
    }
}
