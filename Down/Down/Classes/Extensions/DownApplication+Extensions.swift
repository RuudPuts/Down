//
//  DownApplication+Extensions.swift
//  Down
//
//  Created by Ruud Puts on 12/11/16.
//  Copyright © 2016 Ruud Puts. All rights reserved.
//

import DownKit
import Rswift

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
        case .Down: return nil
            
        case .SabNZBd: return R.image.sabnzbdIcon()
        case .Sickbeard: return R.image.sickbeardIcon()
        case .CouchPotato: return R.image.couchpotatoIcon()
        }
    }
}
