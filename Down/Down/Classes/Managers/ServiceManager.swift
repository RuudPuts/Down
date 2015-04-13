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
    }
    
    func sabNZBdQueueUpdated() {
        matchSabNZBdItemsWithSickbeardHistory(sabNZBdItems: sabNZBdService.queue)
    }
    
    func sabNZBdHistoryUpdated() {
        matchSabNZBdItemsWithSickbeardHistory(sabNZBdItems: sabNZBdService.history)
    }
    
    func sickbeardHistoryUpdated() {
        matchSabNZBdItemsWithSickbeardHistory(sabNZBdItems: sabNZBdService.queue)
        matchSabNZBdItemsWithSickbeardHistory(sabNZBdItems: sabNZBdService.history)
    }
    
    private func matchSabNZBdItemsWithSickbeardHistory(#sabNZBdItems: [SABItem]) {
        for sabNZBdItem: SABItem in sabNZBdItems {
            sabNZBdItem.sickbeardEntry = sickbeardService.historyItemWithResource(sabNZBdItem.filename)
        }
    }
   
}
