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
        speedLabel?.text = R.string.localizable.download_statusview_speed()
        timeRemainingLabel?.text = R.string.localizable.download_statusview_timeremaining()
        mbRemainingLabel?.text = R.string.localizable.download_statusview_mbremaining()
    }

    var queue: DownloadQueue? {
        didSet {
            if queue?.currentSpeed == "0" {
                [speedValueLabel, timeRemainingValueLabel, mbRemainingValueLabel].forEach {
                    $0?.text = "-"
                }
                
                heightConstraint?.constant = 0
            }
            else {
                speedValueLabel?.text = queue?.currentSpeed
                timeRemainingValueLabel?.text = queue?.timeRemaining
                mbRemainingValueLabel?.text = queue?.mbRemaining

                heightConstraint?.constant = 50
            }

            layoutIfNeeded()
        }
    }
}

extension Reactive where Base: DownloadQueueStatusView {
    var queue: ControlProperty<DownloadQueue?> {
        let source: Observable<DownloadQueue?> = Observable.deferred { [weak statusView = self.base as DownloadQueueStatusView] () -> Observable<DownloadQueue?> in
            return Observable.just(statusView?.queue)
        }

        let bindingObserver = Binder(self.base) { (statusView, queue: DownloadQueue?) in
            statusView.queue = queue
        }

        return ControlProperty(values: source, valueSink: bindingObserver)
    }
}
