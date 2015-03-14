//
//  ServiceManager.swift
//  Down
//
//  Created by Ruud Puts on 14/03/15.
//  Copyright (c) 2015 Ruud Puts. All rights reserved.
//

import UIKit

class ServiceManager: NSObject {
    
    let sabNZBdService: SabNZBdService
    let sickbeardServcie: SickbeardService
    let couchPotatoService: CouchPotatoService
    
    override init() {
        sabNZBdService = SabNZBdService(queueRefreshRate: 2, historyRefreshRate: 4)
        sickbeardServcie = SickbeardService()
        couchPotatoService = CouchPotatoService()
    }
   
}
