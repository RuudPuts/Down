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
    @IBOutlet weak var speedLabel: UILabel?
    @IBOutlet weak var timeRemainingLabel: UILabel?
    @IBOutlet weak var mbRemainingLabel: UILabel?

    @IBOutlet weak var speedValueLabel: UILabel?
    @IBOutlet weak var timeRemainingValueLabel: UILabel?
    @IBOutlet weak var mbRemainingValueLabel: UILabel?

    override func awakeFromNib() {
        style(as: .defaultQueueStatusView)
        speedLabel?.text = R.string.localizable.download_statusview_speed()
        timeRemainingLabel?.text = R.string.localizable.download_statusview_timeremaining()
        mbRemainingLabel?.text = R.string.localizable.download_statusview_mbremaining()
    }

    var queue: DownloadQueue? {
        didSet {
            if queue?.speedMb == 0 {
                heightConstraint?.constant = 0
            }
            else {
                speedValueLabel?.text = displayString(forSpeed: queue?.speedMb ?? 0)
                timeRemainingValueLabel?.text = queue?.remainingTime.displayString
                mbRemainingValueLabel?.text = displayString(forMb: queue?.remainingMb ?? 0)

                heightConstraint?.constant = 50
            }

            layoutIfNeeded()
        }
    }
}

extension Reactive where Base: DownloadQueueStatusView {
    var queue: Binder<DownloadQueue?> {
        return Binder(base) { statusView, queue in
            statusView.queue = queue
        }
    }
}

private extension DownloadQueueStatusView {
    func displayString(forMb mb: Double) -> String {
        var amount = max(mb, 0)
        var label = "MB"

        if amount > 1024 {
            amount /= 1024
            label = "GB"
        }
        else if amount < 1 {
            amount *= 1024
            label = "KB"
        }

        return String(format: "%.1f", amount) + " " + label
    }

    func displayString(forSpeed mbSpeed: Double) -> String {
        return "\(displayString(forMb: mbSpeed))/s"
    }
}
