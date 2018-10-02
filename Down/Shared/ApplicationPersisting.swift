//
//  ApplicationPersisting.swift
//  DownKit
//
//  Created by Ruud Puts on 19/07/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import DownKit

protocol ApplicationPersisting {
    func load(type: DownApplicationType) -> ApiApplication?
    func store(_ application: ApiApplication)
}

extension UserDefaults: ApplicationPersisting {
    func load(type: DownApplicationType) -> ApiApplication? {
        guard let host = object(forKey: "\(type.rawValue)_host") as? String,
              let apiKey = object(forKey: "\(type.rawValue)_apikey") as? String else {
            return nil
        }

        //! hmmmm, I need this evil somewhere...
        switch type {
        case .sabnzbd:
            return DownloadApplication(type: .sabnzbd, host: host, apiKey: apiKey)
        case .sickbeard:
            return DvrApplication(type: .sickbeard, host: host, apiKey: apiKey)
        case .couchpotato:
            return DmrApplication(type: .couchpotato, host: host, apiKey: apiKey)
        }
    }

    func store(_ application: ApiApplication) {
        set(application.host, forKey: "\(application.downType.rawValue)_host")
        set(application.apiKey, forKey: "\(application.downType.rawValue)_apikey")
        synchronize()
    }
}
