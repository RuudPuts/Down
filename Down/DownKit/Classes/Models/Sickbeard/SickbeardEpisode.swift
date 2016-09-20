//
//  SickbeardShow.swift
//  Down
//
//  Created by Ruud Puts on 06/09/15.
//  Copyright © 2015 Ruud Puts. All rights reserved.
//

import Foundation
import RealmSwift

public class SickbeardEpisode: Object {
    public dynamic var uniqueId = NSUUID().UUIDString
    public dynamic var id = 0
    public dynamic var name = ""
    public dynamic var airDate: NSDate? = nil
    public dynamic var quality = ""
    public dynamic var plot = ""
    
    public var status: SickbeardEpisodeStatus {
        get {
            return SickbeardEpisodeStatus(rawValue: statusString) ?? .Unknown
        }
        set {
//            if statusString.length == 0 {
//                DownDatabase.shared.write {
//                    self.statusString = newValue.rawValue
//                }
//            }
//            else {
//                setStatus(newValue, completion: { error in
//                    guard error != nil else {
//                        return
//                    }
//                    
//                    self.statusString = newValue.rawValue
//                })
//            }
        
            statusString = newValue.rawValue
        }
    }
    private dynamic var statusString = ""
    
    // TODO: show and season should not be optional (or maybe only internal..?)
    public dynamic weak var show: SickbeardShow?
    public dynamic weak var season: SickbeardSeason?
    
    public enum SickbeardEpisodeStatus: String {
        case Unknown
        case Ignored
        case Archived
        case Unaired
        case Skipped
        case Wanted
        case Snatched
        case Downloaded
        
        static var updatable: [SickbeardEpisodeStatus] {
            return [.Wanted, .Skipped, .Archived, .Ignored]
        }
    }
    
    // MARK: Realm
    
    public override static func primaryKey() -> String {
        return "uniqueId"
    }
    
    // MARK: Public getters
    
    public var title: String {
        var title = name
        if season != nil && show != nil {
            title = String(format: "%@ - S%02dE%02d - %@", show!.name, season!.id, id, name)
        }
        return title
    }
    
    public var daysUntilAiring: Int {
        let today = NSDate().dateWithoutTime()
        
        if let date = airDate where date >= today {
            let calendar = NSCalendar.currentCalendar()
            return calendar.components(.Day, fromDate: today, toDate: date, options: []).day
        }
        
        return -1
    }
    
    // MARK: Functions
    
    public func update(status: SickbeardEpisodeStatus, completion:((NSError?) -> (Void))?) {
        SickbeardService.shared.update(status, forEpisode: self, completion: { error in
            if let error = error {
                NSLog("Error while updating episode status: \(error)")
            }
            
            DownDatabase.shared.write {
                self.status = status
            }
            
            if let completion = completion {
                completion(error)
            }
        })
    }
    
}

extension Results where T: SickbeardEpisode {
    
    public func sortOldestFirst() -> RealmSwift.Results<T> {
        return self.sorted([SortDescriptor(property:"airDate", ascending: true), SortDescriptor(property:"id", ascending: true)])
    }
    
    public func sortNewestFirst() -> RealmSwift.Results<T> {
        return self.sorted([SortDescriptor(property:"airDate", ascending: false), SortDescriptor(property:"id", ascending: true)])
    }
    
}