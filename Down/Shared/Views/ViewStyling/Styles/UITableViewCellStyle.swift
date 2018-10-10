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

    static func selectableCell(application: DownApplicationType) -> ViewStyling {
        return ViewStyling {
            let view = UIView()
            view.backgroundColor = Stylesheet.Colors
                .primaryColor(for: application)
                .withAlphaComponent(0.3)
            $0.selectedBackgroundView = view
        }
    }
}

extension ViewStyling where ViewType == DownloadItemCell {
    static var downloadItem = ViewStyling {
        $0.style(as: .defaultCell)
        $0.progressView.style(as: .defaultProgressView)
        $0.containerView.style(as: .roundedContentView)

        $0.backgroundColor = .clear
        $0.nameLabel?.style(as: .titleLabel)
        $0.statusLabel?.style(as: .detailLabel)
        $0.timeLabel?.style(as: .detailLabel)
    }
}
