//
//  DownloadQueueStatusView.swift
//  Down
//
//  Created by Ruud Puts on 08/07/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import UIKit
import DownKit
import RxSwift
import RxCocoa

class DownloadQueueStatusView: DesignableView {
    @IBOutlet weak var unpausedView: UIView?

    @IBOutlet weak var speedLabel: UILabel?
    @IBOutlet weak var timeRemainingLabel: UILabel?
    @IBOutlet weak var mbRemainingLabel: UILabel?

    @IBOutlet weak var speedValueLabel: UILabel?
    @IBOutlet weak var timeRemainingValueLabel: UILabel?
    @IBOutlet weak var mbRemainingValueLabel: UILabel?

    @IBOutlet weak var pausedView: UIView?
    @IBOutlet weak var pausedImageView: UIImageView?
    @IBOutlet weak var pausedLabel: UILabel?

    override func awakeFromNib() {
        super.awakeFromNib()
        
        applyStyling()
        applyLocalization()
    }

    var queue: DownloadQueue? {
        didSet {
            let queuePaused = queue?.isPaused ?? false
            pausedView?.isHidden = !queuePaused
            unpausedView?.isHidden = queuePaused

            speedValueLabel?.text = String.displayString(forSpeed: queue?.speedMb ?? 0)
            timeRemainingValueLabel?.text = queue?.remainingTime.displayString
            mbRemainingValueLabel?.text = String.displayString(forMb: queue?.remainingMb ?? 0)
        }
    }

    private func applyStyling() {
        backgroundColor = .clear

        [speedLabel, timeRemainingLabel, mbRemainingLabel].forEach {
            $0?.font = Stylesheet.Fonts.regularFont(ofSize: 18)
            $0?.textColor = Stylesheet.Colors.white
        }

        [speedValueLabel, timeRemainingValueLabel, mbRemainingValueLabel].forEach {
            $0?.font = Stylesheet.Fonts.lightFont(ofSize: 16)
            $0?.textColor = Stylesheet.Colors.white
        }
        
        pausedLabel?.style(as: .detailLabel)
    }

    private func applyLocalization() {
        speedLabel?.text = R.string.localizable.download_statusview_speed()
        timeRemainingLabel?.text = R.string.localizable.download_statusview_timeremaining()
        mbRemainingLabel?.text = R.string.localizable.download_statusview_mbremaining()
        pausedLabel?.text = "Downloads are paused"
    }
}

extension DownloadQueueStatusView {
    func configure(with application: DownloadApplication) {
        pausedImageView?.style(as: .imageView(for: application.downType))
    }
}

extension Reactive where Base: DownloadQueueStatusView {
    var queue: Binder<DownloadQueue?> {
        return Binder(base) { statusView, queue in
            statusView.queue = queue
        }
    }
}
