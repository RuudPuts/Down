//
//  SickbeardFutureItem.swift
//  Down
//
//  Created by Ruud Puts on 19/07/15.
//  Copyright © 2015 Ruud Puts. All rights reserved.
//

import Foundation

class SickbeardFutureItem: SickbeardItem {
    var episodeName: String!
    var airDate: String!
    var category: Category!
    
    enum Category : String {
        case Today = "today", Soon = "soon", Later = "later", Missed = "missed"
        
        static let values = [Today, Soon, Later, Missed]
    }
    
    init(_ tvdbId: Int, _ showName: String, _ season: Int, _ episode: Int, _ status: String, _ episodeName: String, _ airDate: String, _ category: Category) {
        super.init(tvdbId, showName, season, episode: episode, status)
        self.status = .Comming
        self.episodeName = episodeName
        self.airDate = airDate
        self.category = category
    }
    
    override var displayName: String! {
        return super.displayName + " - \(episodeName)"
    }
}