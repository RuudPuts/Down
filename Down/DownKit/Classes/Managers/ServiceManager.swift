//
//  ServiceManager.swift
//  Down
//
//  Created by Ruud Puts on 14/03/15.
//  Copyright (c) 2015 Ruud Puts. All rights reserved.
//

import UIKit

public class ServiceManager: NSObject, SabNZBdListener, SickbeardListener {
    
    public let sabNZBdService: SabNZBdService
    public let sickbeardService: SickbeardService
    public let couchPotatoService: CouchPotatoService
    
    public override init() {
        sabNZBdService = SabNZBdService(queueRefreshRate: 1, historyRefreshRate: 1)
        sickbeardService = SickbeardService()
        couchPotatoService = CouchPotatoService()
        
        super.init()
        
//fix        sabNZBdService.addListener(self)
//fix        sickbeardService.addListener(self)
    }
    
    // MARK: SabNZBdListener
    
    public func sabNZBdQueueUpdated() {
        matchSabNZBdItemsWithSickbeardHistory(sabNZBdService.queue)
    }
    
    public func sabNZBdHistoryUpdated() {
        matchSabNZBdItemsWithSickbeardHistory(sabNZBdService.history)
    }
    
    public func sabNZBDFullHistoryFetched() { }

    // MARK: SickbearListener
    
    public func sickbeardHistoryUpdated() {
        matchSabNZBdItemsWithSickbeardHistory(sabNZBdService.queue)
        matchSabNZBdItemsWithSickbeardHistory(sabNZBdService.history)
    }
    
    public func sickbeardFutureUpdated() {
        matchSabNZBdItemsWithSickbeardHistory(sabNZBdService.queue)
        matchSabNZBdItemsWithSickbeardHistory(sabNZBdService.history)
    }
    
    // MARK: Private methods
    
    private func matchSabNZBdItemsWithSickbeardHistory(sabNZBdItems: [SABItem]) {
        for sabNZBdItem in sabNZBdItems {
            sabNZBdItem.sickbeardEntry = sickbeardService.historyItemWithResource(sabNZBdItem.filename)
        }
    }
   
}
