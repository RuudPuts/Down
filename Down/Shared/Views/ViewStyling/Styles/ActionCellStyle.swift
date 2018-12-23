//
//  ActionCellStyle.swift
//  Down
//
//  Created by Ruud Puts on 22/12/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import DownKit
import XLActionController

extension ViewStyling where ViewType: DownActionCell {
    static func actionCell(for type: DownApplicationType, actionStyle: ActionStyle) -> ViewStyling {
        return ViewStyling {
            $0.style(as: .backgroundView)

            if let titleLabel = $0.actionTitleLabel {
                titleLabel.style(as: .titleLabel)

                switch actionStyle {
                case .cancel: titleLabel.textColor = titleLabel.textColor.withAlphaComponent(0.8)
                case .destructive: titleLabel.textColor = Stylesheet.Colors.red
                case .`default`: break
                }
            }

            if let imageView = $0.actionImageView {
                imageView.style(as: .imageView(for: type))
                imageView.contentMode = .scaleAspectFit
            }

            let selectedColor = Stylesheet.Colors
                .primaryColor(for: type)
                .withAlphaComponent(0.3)
            $0.selectedBackgroundView?.backgroundColor = selectedColor
        }
    }
}
