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
    func remove(_ application: ApiApplication)

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
        case .down: fatalError("Down application can't be constructed")
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
        guard let host = value(forKey: hostStorageKey(for: type)) as? String,
              let apiKey = value(forKey: apiKeyStorageKey(for: type)) as? String else {
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
        case .down:
            fatalError("Down application can't be constructed")
        }
    }

    func store(_ application: ApiApplication) {
        set(application.downType.rawValue, forKey: activeStorageKey(for: application.type))
        set(application.host, forKey: hostStorageKey(for: application.downType))
        set(application.apiKey, forKey: apiKeyStorageKey(for: application.downType))
        synchronize()
    }

    func remove(_ application: ApiApplication) {
        removeObject(forKey: hostStorageKey(for: application.downType))
        removeObject(forKey: apiKeyStorageKey(for: application.downType))

        if isActive(type: application.downType) {
            removeObject(forKey: activeStorageKey(for: application.type))
        }
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
    func hostStorageKey(for applicationType: DownApplicationType) -> String {
        return "\(applicationType.rawValue)_host"
    }

    func apiKeyStorageKey(for applicationType: DownApplicationType) -> String {
        return "\(applicationType.rawValue)_apikey"
    }

    func activeStorageKey(for applicationType: ApiApplicationType) -> String {
        return "\(applicationType.rawValue)_active"
    }
}
