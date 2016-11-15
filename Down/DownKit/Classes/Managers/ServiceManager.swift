//
//  ServiceManager.swift
//  Down
//
//  Created by Ruud Puts on 14/03/15.
//  Copyright (c) 2015 Ruud Puts. All rights reserved.
//

import UIKit

open class ServiceManager: NSObject, SabNZBdListener, SickbeardListener {
    
    public override init() {
        super.init()
        
        SabNZBdService.shared.addListener(self)
        SickbeardService.shared.addListener(self)
    }
    
    open func startAllServices() {
        SabNZBdService.shared.startService()
        SickbeardService.shared.startService()
        CouchPotatoService.shared.startService()
    }
    
    open func stopAllServices() {
        SabNZBdService.shared.stopService()
        SickbeardService.shared.stopService()
        CouchPotatoService.shared.stopService()
    }
    
    // MARK: SabNZBdListener
    
    open func sabNZBdQueueUpdated() {
        matchSabNZBdItemsWithSickbeardHistory(SabNZBdService.shared.queue)
    }
    
    open func sabNZBdHistoryUpdated() {
        matchSabNZBdItemsWithSickbeardHistory(SabNZBdService.shared.history)
    }
    
    open func sabNZBDFullHistoryFetched() { }
    open func willRemoveSABItem(_ sabItem: SABItem) { }

    // MARK: SickbearListener
    
    open func sickbeardShowCacheUpdated() {
        matchSabNZBdItemsWithSickbeardHistory(SabNZBdService.shared.queue)
        matchSabNZBdItemsWithSickbeardHistory(SabNZBdService.shared.history)
    }
    
    // MARK: Private methods
    
    fileprivate func matchSabNZBdItemsWithSickbeardHistory(_ sabNZBdItems: [SABItem]) {
        for sabNZBdItem in sabNZBdItems {
            if let episode = sabNZBdItem.sickbeardEpisode, !episode.isInvalidated {
                continue
            }
            
            sabNZBdItem.sickbeardEpisode = SickbeardService.shared.parseNzbName(sabNZBdItem.nzbName)
        }
    }
   
}
