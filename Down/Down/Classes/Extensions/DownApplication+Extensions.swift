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
        case .down: return UIColor.downRedColor()
            
        case .sabNZBd: return .downSabNZBdColor()
        case .sickbeard: return .downSickbeardColor()
        case .couchPotato: return .downCouchPotatoColor()
        }
    }
    
    var darkColor: UIColor {
        switch self {
        case .down: return UIColor.downRedColor()
            
        case .sabNZBd: return .downSabNZBdDarkColor()
        case .sickbeard: return .downSickbeardDarkColor()
        case .couchPotato: return .downCouchPotatoDarkColor()
        }
    }
    
    var icon: UIImage? {
        switch self {
        case .down: return nil
            
        case .sabNZBd: return R.image.sabnzbdIcon()
        case .sickbeard: return R.image.sickbeardIcon()
        case .couchPotato: return R.image.couchpotatoIcon()
        }
    }
}
