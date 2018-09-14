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
    static var defaultCell = ViewStyling {
        $0.backgroundColor = .clear
        $0.textLabel?.style(as: .titleLabel)
        $0.detailTextLabel?.style(as: .detailLabel)
    }
}

extension ViewStyling where ViewType == DownloadItemCell {
    static var downloadItem = ViewStyling {
        $0.style(as: .defaultCell)
        $0.progressView.style(as: .defaultProgressView)
        $0.containerView.style(as: .contentView)

        $0.nameLabel?.style(as: .titleLabel)
        $0.statusLabel?.style(as: .detailLabel)
        $0.timeLabel?.style(as: .detailLabel)
    }

    static var alternateDownloadItem = ViewStyling {
        $0.style(as: .downloadItem)
        $0.containerView.backgroundColor = .clear
        $0.progressView.centerFillColor = .clear
    }
}
