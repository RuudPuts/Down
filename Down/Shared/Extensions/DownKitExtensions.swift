//
//  DownKitExtensions.swift
//  Down
//
//  Created by Ruud Puts on 08/09/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import DownKit
import RxSwift
import Result
import RxResult

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

extension DownloadItem {
    var displayName: String {
        if let episode = dvrEpisode,
            let seasonIdentifierString = episode.seasonIdentifierString {
            return "\(episode.show.name) - \(seasonIdentifierString) - \(episode.name)"
        }

        return name
    }
}

extension DownloadQueueItem.State {
    var displayName: String {
        switch self {
        case .queued: return "Queued"
        case .grabbing: return "Fetching NZB"
        case .downloading: return "Downloading"
        case .unknown: return String()
        }
    }
}

extension DownloadHistoryItem.State {
    var displayName: String {
        switch self {
        case .queued: return "Queued"
        case .verifying: return "Verifying"
        case .repairing: return "Repairing"
        case .extracting: return "Extracting"
        case .postProcessing: return "Processing"
        case .failed: return "Failed"
        case .completed: return "Completed"
        case .unknown: return String()
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

extension DvrEpisode {
    var seasonIdentifierString: String? {
        guard let episodeId = Int(identifier),
              let seasonId = Int(season.identifier) else {
            return nil
        }

        return String(format: "S%02dE%02d", seasonId, episodeId)
    }

    var displayName: String {
        guard let seasonIdentifier = seasonIdentifierString else {
            return name
        }

        return "\(seasonIdentifier) - \(name)"
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
        case .unaired: return "Unaired"
        case .snatched: return "Snatched"
        case .downloaded: return "Downloaded"
        }
    }
}

extension ObservableInteractor {
    func observeResult() -> Observable<Result<Element, DownError>> {
        return observe()
            .asObservable()
            .mapResult(DownError.self)
    }
}
