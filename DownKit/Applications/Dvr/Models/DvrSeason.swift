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
    
    public convenience init(identifier: String, episodes: [DvrEpisode]) {
        self.init()
        self.identifier = identifier
        self.episodes = List<DvrEpisode>(episodes)
    }
    
    override public static func primaryKey() -> String? {
        return "key"
    }
}
