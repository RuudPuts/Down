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
    @objc public dynamic var identifier = 0
    @objc public dynamic var name = ""
    @objc public dynamic var airDate: Date?
    @objc public dynamic var quality = ""
    @objc public dynamic var plot = ""
    
    public var status: Status {
        get {
            return Status(rawValue: statusString) ?? .unknown
        }
        set {
            statusString = newValue.rawValue
        }
    }
    @objc fileprivate dynamic var statusString = ""
    
    @objc public dynamic weak var show: SickbeardShow?
    @objc public dynamic weak var season: SickbeardSeason?
    
    public enum Status: String {
        case unknown = "Unknown"
        case ignored = "Ignored"
        case archived = "Archived"
        case unaired = "Unaired"
        case skipped = "Skipped"
        case wanted = "Wanted"
        case snatched = "Snatched"
        case downloaded = "Downloaded"
        
        static var updatable: [Status] {
            return [.wanted, .skipped, .archived, .ignored]
        }
    }
    
    // MARK: Realm
    
    public override static func primaryKey() -> String {
        return "uniqueId"
    }

    // TODO: refactor to ==
    public func isSame(_ episode: SickbeardEpisode) -> Bool {
        return show?.tvdbId == episode.show?.tvdbId &&
            season?.identifier == episode.season?.identifier &&
            identifier == episode.identifier
    }
    
    // MARK: Public getters
    
    public var title: String {
        var title = name
        if season != nil && show != nil {
            title = String(format: "%@ - S%02dE%02d - %@", show!.name, season!.identifier, identifier, name)
        }
        return title
    }
    
    public var daysUntilAiring: Int {
        let today = Date().withoutTime()
        
        if let date = airDate, date >= today {
            let calendar = Calendar.current
            return (calendar as NSCalendar).components(.day, from: today, to: date, options: []).day ?? -1
        }
        
        return -1
    }
    
    // MARK: Functions
    
    public func update(_ status: Status, completion: ((Error?) -> Void)?) {
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

extension Results where Element: SickbeardEpisode {
    
    public func sortOldestFirst() -> RealmSwift.Results<Element> {
        return self.sorted(by: [SortDescriptor(keyPath: "airDate", ascending: true),
                                SortDescriptor(keyPath: "id", ascending: true)])
    }
    
    public func sortNewestFirst() -> RealmSwift.Results<Element> {
        return self.sorted(by: [SortDescriptor(keyPath: "airDate", ascending: false),
                                SortDescriptor(keyPath: "id", ascending: true)])
    }
    
}
