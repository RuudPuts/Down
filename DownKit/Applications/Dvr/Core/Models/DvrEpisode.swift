//
//  DvrEpisode.swift
//  DownKit
//
//  Created by Ruud Puts on 21/06/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import RealmSwift

public class DvrEpisode: Object {
    @objc public dynamic var uniqueIdentifier = ""
    @objc public dynamic var identifier = "" {
        didSet {
            updateUniqueIdentifier()
        }
    }

    @objc public dynamic var show: DvrShow! {
        didSet {
            updateUniqueIdentifier()
        }
    }

    @objc public dynamic var season: DvrSeason! {
        didSet {
            updateUniqueIdentifier()
        }
    }

    @objc public dynamic var name = ""
    @objc public dynamic var summary: String?
    @objc public dynamic var airdate: Date?
    @objc public dynamic var quality = Quality.unknown
    @objc public dynamic var status = DvrEpisodeStatus.unknown

    public convenience init(identifier: String, name: String, summary: String? = nil, airdate: Date?,
                            quality: Quality = .unknown, status: DvrEpisodeStatus = .unknown) {
        self.init()
        self.identifier = identifier
        self.name = name
        self.summary = summary
        self.airdate = airdate
        self.quality = quality
        self.status = status
    }
    
    override public static func primaryKey() -> String? {
        return "uniqueIdentifier"
    }

    private func updateUniqueIdentifier() {
        //! Would like to use show.identifier, but for sickbeard it's not set when updating last
        let showIdentifier = show?.name ?? ""
        let seasonIdentifier = season?.identifier ?? ""

        uniqueIdentifier = "\(showIdentifier)-\(seasonIdentifier)-\(identifier)"
    }
}

public extension DvrEpisode {
    var isSpecial: Bool {
        return season.identifier == "0"
    }
}

internal extension DvrEpisode {
    func clone() -> DvrEpisode {
        let clone = DvrEpisode(identifier: identifier,
                               name: name,
                               summary: summary,
                               airdate: airdate,
                               quality: quality,
                               status: status)
        clone.season = season
        clone.show = show

        return clone
    }
}

@objc
public enum DvrEpisodeStatus: Int, CaseIterable {
    case unknown
    case wanted
    case skipped
    case archived
    case ignored
    case snatched
    case downloaded
    case unaired
}
