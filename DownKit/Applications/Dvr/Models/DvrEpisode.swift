//
//  DvrEpisode.swift
//  DownKit
//
//  Created by Ruud Puts on 21/06/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import RealmSwift

public class DvrEpisode: Object {
    @objc dynamic var key = UUID().uuidString
    @objc public dynamic var identifier = ""
    @objc public dynamic var name = ""
    @objc public dynamic var airdate = ""
    @objc public dynamic var quality = ""
    @objc public dynamic var status = ""
    
    public convenience init(identifier: String, name: String, airdate: String, quality: String, status: String) {
        self.init()
        self.identifier = identifier
        self.name = name
        self.airdate = airdate
        self.quality = quality
        self.status = status
    }
    
    override public static func primaryKey() -> String? {
        return "key"
    }
}
