//
//  DvrShow.swift
//  Down
//
//  Created by Ruud Puts on 12/01/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

struct DvrShow {
    let identifier: String
    let name: String
    var quality: String
    var seasons: [DvrSeason]?
    
    init(identifier: String, name: String, quality: String) {
        self.identifier = identifier
        self.name = name
        self.quality = quality
    }
}

struct DvrSeason {
    let identifier: String
    let episodes: [DvrEpisode]
}

struct DvrEpisode {
    let identifier: String
    let name: String
    let airdate: String
    let quality: String
    let status: String
}
