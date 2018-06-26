//
//  Down.swift
//  Down
//
//  Created by Ruud Puts on 03/06/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import DownKit

class Down: Application {
    var name = "Down"
    
    static var applicationFactory: ApplicationProducing = ApplicationFactory()
    static var downloadApplication: DownloadApplication = applicationFactory.makeDownload(type: .sabnzbd)
    static var dvrApplication: DvrApplication = applicationFactory.makeDvr(type: .sickbeard)
}
