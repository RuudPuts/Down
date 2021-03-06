//
//  DvrSeason.swift
//  DownKit
//
//  Created by Ruud Puts on 21/06/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import RealmSwift

public class DvrSeason: Object, CascadeDeletable {
    @objc dynamic var uniqueIdentifier = ""
    @objc public dynamic var identifier = "" {
        didSet { updateUniqueIdentifier() }
    }

    @objc public dynamic var show: DvrShow! {
        didSet { updateUniqueIdentifier() }
    }

    public var episodes = List<DvrEpisode>()

    public convenience init(identifier: String, episodes: [DvrEpisode], show: DvrShow) {
        self.init()
        self.identifier = identifier
        self.show = show

        setEpisodes(episodes)
    }

    override public static func primaryKey() -> String? {
        return "uniqueIdentifier"
    }

    var propertiesToCascadeDelete: [String] {
        return ["episodes"]
    }

    private func updateUniqueIdentifier() {
        //! Would like to use show.identifier, but for sickbeard it's not set when updating last
        let showIdentifier = show?.name ?? ""

        uniqueIdentifier = "\(showIdentifier)-\(identifier)"
    }
}

extension DvrSeason {
    func setEpisodes(_ newEpisodes: [DvrEpisode]) {
        let episodes = List<DvrEpisode>()

        newEpisodes
            .sorted(by: { lhs, rhs in
                return lhs.identifier.compare(rhs.identifier, options: .numeric) == .orderedAscending
            })
            .forEach {
                $0.show = show
                $0.season = self
                episodes.append($0)
            }

        self.episodes = episodes
    }
}

public extension DvrSeason {
    var isSpecials: Bool {
        return identifier == "0"
    }
}
