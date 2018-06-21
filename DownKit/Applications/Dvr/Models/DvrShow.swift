//
//  DvrShow.swift
//  Down
//
//  Created by Ruud Puts on 12/01/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import RealmSwift

public class DvrShow: Object {
    @objc dynamic var key = UUID().uuidString
    @objc public dynamic var identifier: String = String(NSNotFound)
    @objc public dynamic var name = ""
    @objc public dynamic var quality = ""
    public var seasons = List<DvrSeason>()
    
    public convenience init(identifier: String, name: String, quality: String) {
        self.init()
        self.identifier = identifier
        self.name = name
        self.quality = quality
    }
    
    public func setSeasons(_ seasons: [DvrSeason]) {
        self.seasons = List<DvrSeason>(seasons)
    }
    
    override public static func primaryKey() -> String? {
        return "key"
    }
}

extension DvrShow {
    static var partialIdentifier: String {
        return String(NSNotFound)
    }
    
    var isPartial: Bool {
        return identifier == String(NSNotFound)
    }
}

extension DvrShow: DvrDatabaseStoring {
    func store(in database: DvrDatabase) {
        guard !isPartial else { return }
        
        database.store(show: self)
    }
}
