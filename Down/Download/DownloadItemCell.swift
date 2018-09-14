//
//  DownloadItemCell.swift
//  Down
//
//  Created by Ruud Puts on 26/06/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import UIKit
import DownKit
import CircleProgressView

class DownloadItemCell: UITableViewCell {
    static let identifier = String(describing: DownloadItemCell.self)
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!

    @IBOutlet weak var progressView: CircleProgressView!

    var viewModel: DownloadItemCellModel! {
        didSet {
            nameLabel?.text = viewModel.name
            statusLabel?.text = viewModel.status
            timeLabel?.text = viewModel.time

            progressView.isHidden = !viewModel.hasProgress
            progressView.progress = viewModel.progress

            setNeedsLayout()
        }
    }

    func applyStyling(for indexPath: IndexPath) {
        if indexPath.row % 2 == 0 {
            style(as: .downloadItem)
        }
        else {
            style(as: .alternateDownloadItem)
        }

        progressView.style(as: .progressView(for: .sabnzbd))
    }

    func setViewModel(_ viewModel: DownloadItemCellModel) -> DownloadItemCell {
        self.viewModel = viewModel
        return self
    }
}

struct DownloadItemCellModel {
    var name: String
    var status: String? = nil
    var time: String? = nil
    var hasProgress = false
    var progress = 0.0

    init(item: DownloadItem) {
        if let episode = item.dvrEpisode,
            let episodeId = Int(episode.identifier),
            let seasonId = Int(episode.season.identifier) {
            name = String(format: "%@ - S%02dE%02d - %@",
                          episode.show.name,
                          seasonId,
                          episodeId,
                          episode.name)
        }
        else {
            name = item.name
        }

        self.progress = item.progress / 100
    }

    init(queueItem: DownloadQueueItem) {
        self.init(item: queueItem)
        self.status = queueItem.state.displayName
        self.time = queueItem.remainingTime.displayString
        self.hasProgress = true
    }

    init(historyItem: DownloadHistoryItem) {
        self.init(item: historyItem)
        self.status = historyItem.state.displayName
        self.time = historyItem.finishDate?.dateTimeString
        self.hasProgress = historyItem.state.hasProgress
    }
}

private extension DvrEpisode {
    var displayName: String? {
        guard let show = show,
              let episodeId = Int(identifier),
              let seasonId = Int(season.identifier) else {
            return nil
        }

        return String(format: "%@ - S%02dE%02d - %@",
                               show.name,
                               seasonId,
                               episodeId,
                               name)
    }
}

private extension DownloadQueueItem.State {
    var displayName: String? {
        switch self {
        case .queued: return "Queued"
        case .grabbing: return "Fetching NZB"
        case .downloading: return "Downloading"
        default: return nil
        }
    }
}

private extension DownloadHistoryItem.State {
    var displayName: String? {
        switch self {
        case .queued: return "Queued"
        case .verifying: return "Verifying"
        case .repairing: return "Repairing"
        case .extracting: return "Extracting"
        case .postProcessing: return "Processing"
        case .failed: return "Failed"
        case .completed: return "Completed"
        default: return nil
        }
    }
}
