//
//  View.swift
//  StylingEngine
//
//  Created by Ruud Puts on 17/07/2018.
//  Copyright © 2018 Ruud Puts. All rights reserved.
//

import UIKit
import DownKit

extension ViewStyling where ViewType == UITableViewCell {
}

extension ViewStyling where ViewType == DownloadItemCell {
    static var downloadItem = ViewStyling {
        $0.progressView.style(as: .defaultProgressView)
        $0.containerView.style(as: .cellContentView)

        $0.backgroundColor = .clear
        $0.nameLabel?.style(as: .titleLabel)
        $0.statusLabel?.style(as: .detailLabel)
        $0.timeLabel?.style(as: .detailLabel)
    }
}
