//
//  DvrSeason.swift
//  DownKit
//
//  Created by Ruud Puts on 21/06/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import RealmSwift

public class DvrSeason: Object {
    @objc dynamic var key = UUID().uuidString
    @objc public dynamic var identifier = ""
    public var episodes = List<DvrEpisode>()
    
    @objc public dynamic var show: DvrShow!
    
    public convenience init(identifier: String, episodes: [DvrEpisode], show: DvrShow) {
        self.init()
        self.identifier = identifier
        self.show = show
        
        self.episodes = List<DvrEpisode>(episodes.map {
            $0.show = show
            $0.season = self
            return $0
        })
    }
    
    override public static func primaryKey() -> String? {
        return "key"
    }
}
