//
//  DvrShow.swift
//  Down
//
//  Created by Ruud Puts on 12/01/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

public struct DvrShow {
    public let identifier: String
    public let name: String
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

public struct DvrSeason {
    let identifier: String
    let episodes: [DvrEpisode]
}

public struct DvrEpisode {
    let identifier: String
    let name: String
    let airdate: String
    let quality: String
    let status: String
}
