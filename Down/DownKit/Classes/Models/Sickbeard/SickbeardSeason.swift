//
//  SickbeardShow.swift
//  Down
//
//  Created by Ruud Puts on 06/09/15.
//  Copyright © 2015 Ruud Puts. All rights reserved.
//

import Foundation
import RealmSwift

public class SickbeardSeason: Object {
    @objc public dynamic var uniqueId = UUID().uuidString
    @objc public dynamic var identifier = 0
    // swiftlint:disable identifier_name
    internal var _episodes = List<SickbeardEpisode>()
    
    @objc public dynamic weak var show: SickbeardShow?
    
    // Realm
    
    public override static func primaryKey() -> String {
        return "uniqueId"
    }
    
    // Properties
    
    public var episodes: [SickbeardEpisode] {
        return _episodes.sorted { $0.identifier < $1.identifier }
    }
    
    public var downloadedEpisodes: [SickbeardEpisode] {
        return _episodes.filter { $0.status == .downloaded }
    }
    
    public var title: String {
        var title = "Season \(identifier)"
        if identifier == 0 {
            title = "Specials"
        }
    
        return title
    }
    
    // MARK: Functions
    
    public func getEpisode(_ episodeId: Int) -> SickbeardEpisode? {
        return _episodes.filter { $0.identifier == episodeId }.first
    }
    
    public func update(_ status: SickbeardEpisode.Status, completion: ((Error?) -> Void)?) {
        SickbeardService.shared.update(status, forSeason: self, completion: { error in
            if let error = error {
                Log.e("Error while updating episode status: \(error)")
            }
            
            DownDatabase.shared.write {
                self._episodes.forEach({$0.status = status})
            }
            
            if let completion = completion {
                completion(error)
            }
        })
    }
}
