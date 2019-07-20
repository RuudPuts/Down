//
//  DvrShow.swift
//  Down
//
//  Created by Ruud Puts on 12/01/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import RealmSwift

public class DvrShow: Object, CascadeDeletable {
    @objc public dynamic var identifier = String(NSNotFound)
    @objc public dynamic var name = ""
    @objc public dynamic var quality = Quality.unknown
    @objc public dynamic var status = DvrShowStatus.unknown
    @objc public dynamic var network = ""
    @objc public dynamic var airTime = ""
    public var seasons = List<DvrSeason>()
    
    public convenience init(identifier: String, name: String) {
        self.init()
        self.identifier = identifier
        self.name = name
    }
    
    override public static func primaryKey() -> String? {
        return "identifier"
    }

    var propertiesToCascadeDelete: [String] {
        return ["seasons"]
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

extension DvrShow {
    func setSeasons(_ newSeasons: [DvrSeason]) {
        let seasons = List<DvrSeason>()

        newSeasons
            .sorted(by: { lhs, rhs in
                return lhs.identifier.compare(rhs.identifier, options: .numeric) == .orderedDescending
            })
            .forEach {
                $0.show = self
                $0.episodes.forEach {
                    $0.show = self
                }

                seasons.append($0)
            }

        self.seasons = seasons
    }

    func episodeAired(since referenceDate: Date) -> [DvrEpisode] {
        let now = Date()

        return  seasons
            .flatMap { $0.episodes }
            .filter { $0.airdate?.isBetweeen(date: referenceDate, and: now) ?? true }
    }
}

@objc
public enum DvrShowStatus: Int {
    case unknown
    case continuing
    case ended
}
