//
//  DownKitExtensions.swift
//  Down
//
//  Created by Ruud Puts on 08/09/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import DownKit

extension DownloadItem {
    var displayName: String {
        if let episode = dvrEpisode,
            let episodeId = Int(episode.identifier),
            let seasonId = Int(episode.season.identifier) {
            return String(format: "%@ - S%02dE%02d - %@",
                          episode.show.name,
                          seasonId,
                          episodeId,
                          episode.name)
        }

        return name
    }
}

extension Quality {
    var displayString: String {
        switch self {
        case .hd1080p: return "1080P"
        case .hd720p: return "720P"
        case .hdtv: return "HD TV"
        case .unknown: return ""
        }
    }
}

extension DvrShowStatus {
    var displayString: String {
        switch self {
        case .continuing: return "Continuing"
        case .ended: return "Ended"
        case .unknown: return ""
        }
    }
}

extension DvrEpisodeStatus {
    var displayString: String {
        switch self {
        case .unknown: return "Unkown"
        case .wanted: return "Wanted"
        case .skipped: return "Skipped"
        case .archived: return "Archived"
        case .ignored: return "Ignored"
        case .snatched: return "Snatched"
        case .downloaded: return "Downloaded"
        }
    }
}
