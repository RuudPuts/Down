//
//  DvrShow.swift
//  Down
//
//  Created by Ruud Puts on 12/01/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

public class DvrShow {
    public var identifier: String
    public var name: String
    public var quality: String
    public var seasons: [DvrSeason]?
    
    public init(identifier: String, name: String, quality: String) {
        self.identifier = identifier
        self.name = name
        self.quality = quality
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

public class DvrSeason {
    let identifier: String
    let episodes: [DvrEpisode]
    
    public init(identifier: String, episodes: [DvrEpisode]) {
        self.identifier = identifier
        self.episodes = episodes
    }
}

public class DvrEpisode {
    let identifier: String
    let name: String
    let airdate: String
    let quality: String
    let status: String
    
    public init(identifier: String, name: String, airdate: String, quality: String, status: String) {
        self.identifier = identifier
        self.name = name
        self.airdate = airdate
        self.quality = quality
        self.status = status
    }
}
