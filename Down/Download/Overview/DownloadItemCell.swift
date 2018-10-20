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

    override func awakeFromNib() {
        super.awakeFromNib()

        applyStyling()
    }

    func applyStyling() {
        style(as: .downloadItem)
        progressView.style(as: .progressView(for: .sabnzbd))
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        applyStyling()
    }
}

struct DownloadItemCellModel {
    var name: String
    var status: String? = nil
    var time: String? = nil
    var hasProgress = false
    var progress = 0.0

    init(item: DownloadItem) {
        name = item.displayName
        progress = item.progress / 100
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
