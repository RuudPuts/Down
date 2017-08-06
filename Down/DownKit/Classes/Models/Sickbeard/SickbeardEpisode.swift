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
    @objc public dynamic var uniqueId = UUID().uuidString
    @objc public dynamic var id = 0
    @objc public dynamic var name = ""
    @objc public dynamic var airDate: Date? = nil
    @objc public dynamic var quality = ""
    @objc public dynamic var plot = ""
    
    public var status: Status {
        get {
            return Status(rawValue: statusString) ?? .Unknown
        }
        set {
            statusString = newValue.rawValue
        }
    }
    @objc fileprivate dynamic var statusString = ""
    
    @objc public dynamic weak var show: SickbeardShow?
    @objc public dynamic weak var season: SickbeardSeason?
    
    public enum Status: String {
        case Unknown
        case Ignored
        case Archived
        case Unaired
        case Skipped
        case Wanted
        case Snatched
        case Downloaded
        
        static var updatable: [Status] {
            return [.Wanted, .Skipped, .Archived, .Ignored]
        }
    }
    
    // MARK: Realm
    
    public override static func primaryKey() -> String {
        return "uniqueId"
    }
    
    public func isSame(_ episode: SickbeardEpisode) -> Bool {
        return show?.tvdbId == episode.show?.tvdbId && season?.id == episode.season?.id && id == episode.id
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
        let today = Date().withoutTime()
        
        if let date = airDate , date >= today {
            let calendar = Calendar.current
            return (calendar as NSCalendar).components(.day, from: today, to: date, options: []).day ?? -1
        }
        
        return -1
    }
    
    // MARK: Functions
    
    public func update(_ status: Status, completion:((Error?) -> (Void))?) {
        SickbeardService.shared.update(status, forEpisode: self, completion: { error in
            if let error = error {
                Log.e("Error while updating episode status: \(error)")
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
        return self.sorted(by: [SortDescriptor(keyPath:"airDate", ascending: true), SortDescriptor(keyPath:"id", ascending: true)])
    }
    
    public func sortNewestFirst() -> RealmSwift.Results<T> {
        return self.sorted(by: [SortDescriptor(keyPath:"airDate", ascending: false), SortDescriptor(keyPath:"id", ascending: true)])
    }
    
}
