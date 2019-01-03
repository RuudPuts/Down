//
//  ApplicationPersisting.swift
//  DownKit
//
//  Created by Ruud Puts on 19/07/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import DownKit

protocol ApplicationPersisting {
    func makeApplication(ofType type: DownApplicationType) -> ApiApplication
    func load(type: ApiApplicationType) -> ApiApplication?
    func load(type: DownApplicationType) -> ApiApplication?
    func store(_ application: ApiApplication)

    var anyApplicationConfigured: Bool { get }
    func isConfigured(type: DownApplicationType) -> Bool
    func isActive(type: DownApplicationType) -> Bool
}

extension UserDefaults: ApplicationPersisting {
    func makeApplication(ofType type: DownApplicationType) -> ApiApplication {
        switch type {
        case .sabnzbd: return DownloadApplication(type: .sabnzbd, host: "", apiKey: "")
        case .sickbeard: return DvrApplication(type: .sickbeard, host: "", apiKey: "")
        case .sickgear: return DvrApplication(type: .sickgear, host: "", apiKey: "")
        case .couchpotato: return DmrApplication(type: .couchpotato, host: "", apiKey: "")
        }
    }

    func load(type: ApiApplicationType) -> ApiApplication? {
        guard let rawActiveType = object(forKey: activeStorageKey(for: type)) as? String,
              let activeType = DownApplicationType(rawValue: rawActiveType) else {
            return nil
        }

        return load(type: activeType)
    }

    func load(type: DownApplicationType) -> ApiApplication? {
        guard let host = object(forKey: "\(type.rawValue)_host") as? String,
              let apiKey = object(forKey: "\(type.rawValue)_apikey") as? String else {
            return nil
        }

        switch type {
        case .sabnzbd:
            return DownloadApplication(type: .sabnzbd, host: host, apiKey: apiKey)
        case .sickbeard:
            return DvrApplication(type: .sickbeard, host: host, apiKey: apiKey)
        case .sickgear:
            return DvrApplication(type: .sickgear, host: host, apiKey: apiKey)
        case .couchpotato:
            return DmrApplication(type: .couchpotato, host: host, apiKey: apiKey)
        }
    }

    func store(_ application: ApiApplication) {
        set(application.downType.rawValue, forKey: activeStorageKey(for: application.type))
        set(application.host, forKey: "\(application.downType.rawValue)_host")
        set(application.apiKey, forKey: "\(application.downType.rawValue)_apikey")
        synchronize()
    }

    var anyApplicationConfigured: Bool {
        return !ApiApplicationType.allCases
            .compactMap { load(type: $0) }
            .isEmpty
    }

    func isConfigured(type: DownApplicationType) -> Bool {
        return load(type: type) != nil
    }

    func isActive(type: DownApplicationType) -> Bool {
        return !ApiApplicationType.allCases
            .compactMap { load(type: $0) }
            .filter { $0.downType == type }
            .isEmpty
    }
}

private extension UserDefaults {
    func activeStorageKey(for applicationTyp: ApiApplicationType) -> String {
        return "\(applicationTyp.rawValue)_active"
    }
}
