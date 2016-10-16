//
//  SickbeardShow.swift
//  Down
//
//  Created by Ruud Puts on 06/09/15.
//  Copyright © 2015 Ruud Puts. All rights reserved.
//

import Foundation
import RealmSwift

open class SickbeardEpisode: Object {
    open dynamic var uniqueId = UUID().uuidString
    open dynamic var id = 0
    open dynamic var name = ""
    open dynamic var airDate: Date? = nil
    open dynamic var quality = ""
    open dynamic var plot = ""
    
    open var status: SickbeardEpisodeStatus {
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
    fileprivate dynamic var statusString = ""
    
    // TODO: show and season should not be optional (or maybe only internal..?)
    open dynamic weak var show: SickbeardShow?
    open dynamic weak var season: SickbeardSeason?
    
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
    
    open override static func primaryKey() -> String {
        return "uniqueId"
    }
    
    // MARK: Public getters
    
    open var title: String {
        var title = name
        if season != nil && show != nil {
            title = String(format: "%@ - S%02dE%02d - %@", show!.name, season!.id, id, name)
        }
        return title
    }
    
    open var daysUntilAiring: Int {
        let today = Date().dateWithoutTime()
        
        if let date = airDate , date >= today {
            let calendar = Calendar.current
            return (calendar as NSCalendar).components(.day, from: today, to: date, options: []).day
        }
        
        return -1
    }
    
    // MARK: Functions
    
    open func update(_ status: SickbeardEpisodeStatus, completion:((NSError?) -> (Void))?) {
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
        return self.sorted(by: [SortDescriptor(property:"airDate", ascending: true), SortDescriptor(property:"id", ascending: true)])
    }
    
    public func sortNewestFirst() -> RealmSwift.Results<T> {
        return self.sorted(by: [SortDescriptor(property:"airDate", ascending: false), SortDescriptor(property:"id", ascending: true)])
    }
    
}
