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
        
        sabNZBdService.addListener(self)
        sickbeardService.addListener(self)
    }
    
    public func startAllServices() {
        sabNZBdService.startService()
        sickbeardService.startService()
        couchPotatoService.startService()
    }
    
    public func stopAllServices() {
        sabNZBdService.stopService()
        sickbeardService.stopService()
        couchPotatoService.stopService()
    }
    
    // MARK: SabNZBdListener
    
    public func sabNZBdQueueUpdated() {
        matchSabNZBdItemsWithSickbeardHistory(sabNZBdService.queue)
    }
    
    public func sabNZBdHistoryUpdated() {
        matchSabNZBdItemsWithSickbeardHistory(sabNZBdService.history)
    }
    
    public func sabNZBDFullHistoryFetched() { }
    public func willRemoveSABItem(sabItem: SABItem) { }

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
            guard sabNZBdItem.sickbeardEpisode == nil else {
                continue
            }
            
            sabNZBdItem.sickbeardEpisode = sickbeardService.parseNzbName(sabNZBdItem.nzbName)
        }
    }
   
}
