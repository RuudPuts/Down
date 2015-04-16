//
//  ServiceManager.swift
//  Down
//
//  Created by Ruud Puts on 14/03/15.
//  Copyright (c) 2015 Ruud Puts. All rights reserved.
//

import UIKit

class ServiceManager: NSObject, SabNZBdListener, SickbeardListener {
    
    let sabNZBdService: SabNZBdService
    let sickbeardService: SickbeardService
    let couchPotatoService: CouchPotatoService
    
    override init() {
        sabNZBdService = SabNZBdService(queueRefreshRate: 1, historyRefreshRate: 2)
        sickbeardService = SickbeardService()
        couchPotatoService = CouchPotatoService()
        
        super.init()
        
        sabNZBdService.addListener(self)
        sickbeardService.addListener(self)
    }
    
    func sabNZBdQueueUpdated() {
        matchSabNZBdItemsWithSickbeardHistory(sabNZBdService.queue)
    }
    
    func sabNZBdHistoryUpdated() {
        matchSabNZBdItemsWithSickbeardHistory(sabNZBdService.history)
    }
    
    func sickbeardHistoryUpdated() {
        matchSabNZBdItemsWithSickbeardHistory(sabNZBdService.queue)
        matchSabNZBdItemsWithSickbeardHistory(sabNZBdService.history)
    }
    
    private func matchSabNZBdItemsWithSickbeardHistory(sabNZBdItems: [SABItem]) {
        for sabNZBdItem in sabNZBdItems {
            sabNZBdItem.sickbeardEntry = sickbeardService.historyItemWithResource(sabNZBdItem.filename)
        }
    }
   
}
