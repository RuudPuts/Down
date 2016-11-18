//
//  ServiceManager.swift
//  Down
//
//  Created by Ruud Puts on 14/03/15.
//  Copyright (c) 2015 Ruud Puts. All rights reserved.
//

import UIKit

public class ServiceManager: NSObject, SabNZBdListener, SickbeardListener {
    
    public override init() {
        super.init()
        
        SabNZBdService.shared.addListener(self)
        SickbeardService.shared.addListener(self)
    }
    
    public func startAllServices() {
        SabNZBdService.shared.startService()
        SickbeardService.shared.startService()
        CouchPotatoService.shared.startService()
    }
    
    public func stopAllServices() {
        SabNZBdService.shared.stopService()
        SickbeardService.shared.stopService()
        CouchPotatoService.shared.stopService()
    }
    
    // MARK: SabNZBdListener
    
    public func sabNZBdQueueUpdated() {
        matchSabNZBdItemsWithSickbeardHistory(SabNZBdService.shared.queue)
    }
    
    public func sabNZBdHistoryUpdated() {
        matchSabNZBdItemsWithSickbeardHistory(SabNZBdService.shared.history)
    }
    
    public func sabNZBDFullHistoryFetched() { }
    public func willRemoveSABItem(_ sabItem: SABItem) { }

    // MARK: SickbearListener
    
    public func sickbeardShowCacheUpdated() {
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
