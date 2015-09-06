//
//  SickbeardFutureItem.swift
//  Down
//
//  Created by Ruud Puts on 19/07/15.
//  Copyright © 2015 Ruud Puts. All rights reserved.
//

import Foundation

public class SickbeardFutureItem: SickbeardItem {
    public var airDate: String!
    public var category: Category!
    
    public enum Category : String {
        case Today = "today", Soon = "soon", Later = "later", Missed = "missed"
        
        static let values = [Today, Soon, Later, Missed]
    }
    
    init(_ tvdbId: Int, _ showName: String, _ season: Int, _ episode: Int, _ status: String, _ episodeName: String, _ airDate: String, _ category: Category) {
        super.init(tvdbId, showName, season, episode, episodeName, status)
        self.status = .Comming
        self.airDate = airDate
        self.category = category
    }
    
    override public var displayName: String! {
        return super.displayName + " - \(episodeName)"
    }
}