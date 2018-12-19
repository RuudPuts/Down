//
//  DownApplication.swift
//  Down
//
//  Created by Ruud Puts on 11/07/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

public protocol DownApplication {
    var downType: DownApplicationType { get }
}

public enum DownApplicationType: String {
    case sabnzbd
    case sickbeard
    case sickgear
    case couchpotato

    var displayName: String {
        switch self {
        case .sabnzbd: return "SabNZBd"
        case .sickbeard: return "Sickbeard"
        case .sickgear: return "Sickgear"
        case .couchpotato: return "CouchPotato"
        }
    }
}

// Note on the extensions below. Yes they look odd, but I have to map the types them.

public extension ApiApplication {
    var downType: DownApplicationType {
        // swiftlint:disable:next force_cast
        return (self as! DownApplication).downType
    }
}

extension DownloadApplication: DownApplication {
    public var downType: DownApplicationType {
        switch downloadType {
        case .sabnzbd: return .sabnzbd
        }
    }
}

extension DvrApplication: DownApplication {
    public var downType: DownApplicationType {
        switch dvrType {
        case .sickbeard: return .sickbeard
        case .sickgear: return .sickgear
        }
    }
}

extension DmrApplication: DownApplication {
    public var downType: DownApplicationType {
        switch dmrType {
        case .couchpotato: return .couchpotato
        }
    }
}
