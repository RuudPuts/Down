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
        super.awakeFromNib()
        
        style(as: .defaultQueueStatusView)
        speedLabel?.text = R.string.localizable.download_statusview_speed()
        timeRemainingLabel?.text = R.string.localizable.download_statusview_timeremaining()
        mbRemainingLabel?.text = R.string.localizable.download_statusview_mbremaining()
    }

    var queue: DownloadQueue? {
        didSet {
            speedValueLabel?.text = String.displayString(forSpeed: queue?.speedMb ?? 0)
            timeRemainingValueLabel?.text = queue?.remainingTime.displayString
            mbRemainingValueLabel?.text = String.displayString(forMb: queue?.remainingMb ?? 0)
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
