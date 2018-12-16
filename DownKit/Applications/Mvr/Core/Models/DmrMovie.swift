//
//  DmrShow.swift
//  Down
//
//  Created by Ruud Puts on 30/09/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import RealmSwift

public class DmrMovie: Object {
    @objc public dynamic var identifier = String(NSNotFound)
    @objc public dynamic var imdb_id = ""
    @objc public dynamic var name = ""
    
    public convenience init(identifier: String, imdb_id: String, name: String) {
        self.init()
        self.identifier = identifier
        self.imdb_id = imdb_id
        self.name = name
    }
    
    override public static func primaryKey() -> String? {
        return "identifier"
    }
}
