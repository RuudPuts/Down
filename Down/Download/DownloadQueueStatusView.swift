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

class DownloadQueueStatusView: UIView {
    @IBOutlet weak var speedLabel: UILabel?
    @IBOutlet weak var timeRemainingLabel: UILabel?
    @IBOutlet weak var mbRemainingLabel: UILabel?

    var queue: DownloadQueue? {
        didSet {
            speedLabel?.text = queue?.currentSpeed
            timeRemainingLabel?.text = queue?.timeRemaining
            mbRemainingLabel?.text = queue?.mbRemaining
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
