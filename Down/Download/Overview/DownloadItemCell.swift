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

    override func awakeFromNib() {
        super.awakeFromNib()

        applyStyling()
    }

    private func applyStyling() {
        style(as: .defaultCell)
        progressView.style(as: .defaultProgressView)
        backgroundColor = .clear
        nameLabel?.style(as: .titleLabel)
        statusLabel?.style(as: .detailLabel)
        timeLabel?.style(as: .detailLabel)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        applyStyling()
    }
}

extension DownloadItemCell {
    func configure(with application: DownloadApplication, andItem item: DownloadItem) {
        progressView.style(as: .progressView(for: application.downType))

        nameLabel?.text = item.displayName
        progressView.progress = item.progress / 100

        if let queueItem = item as? DownloadQueueItem {
            configure(with: application, andItem: queueItem)
        }
        else if let historyItem = item as? DownloadHistoryItem {
            configure(with: application, andItem: historyItem)
        }
    }

    private func configure(with application: DownloadApplication, andItem item: DownloadQueueItem) {
        progressView.isHidden = false

        statusLabel.text = item.state.displayName
        timeLabel.text = item.remainingTime.displayString
    }

    private func configure(with application: DownloadApplication, andItem item: DownloadHistoryItem) {
        progressView.isHidden = item.state.hasProgress

        statusLabel.text = item.state.displayName
        timeLabel.text = item.finishDate?.dateTimeString
    }
}
