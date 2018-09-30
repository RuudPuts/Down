//
//  Down.swift
//  Down
//
//  Created by Ruud Puts on 03/06/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import DownKit

class Down {
    static var applicationPersistence: ApplicationPersisting = UserDefaults.standard
    static var downloadApplication = applicationPersistence.load(type: .sabnzbd) as! DownloadApplication
    static var dvrApplication = applicationPersistence.load(type: .sickbeard) as! DvrApplication
    static var dmrApplication = applicationPersistence.load(type: .couchpotato) as! DmrApplication
}
