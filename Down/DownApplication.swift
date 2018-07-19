//
//  DownApplication.swift
//  Down
//
//  Created by Ruud Puts on 11/07/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import DownKit

protocol DownApplication {
    var type: DownApplicationType { get }
}

enum DownApplicationType: String {
    case sabnzbd
    case sickbeard
}

// Note on the extensions below. Yes they look odd, but I have to map the types them.

extension ApiApplication {
    var downType: DownApplicationType {
        return (self as! DownApplication).type
    }
}

extension DownloadApplication: DownApplication {
    var type: DownApplicationType {
        switch downloadType {
        case .sabnzbd: return .sabnzbd
        }
    }
}

extension DvrApplication: DownApplication {
    var type: DownApplicationType {
        switch dvrType {
        case .sickbeard: return .sickbeard
        }
    }
}
