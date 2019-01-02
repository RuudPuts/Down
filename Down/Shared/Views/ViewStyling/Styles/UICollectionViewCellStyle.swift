//
//  UICollectionViewCellStyle.swift
//  Down
//
//  Created by Ruud Puts on 02/01/2019.
//  Copyright © 2019 Mobile Sorcery. All rights reserved.
//

import UIKit
import DownKit

extension ViewStyling where ViewType == UICollectionViewCell {
    static var defaultCollectionViewCell = ViewStyling {
        $0.backgroundColor = .clear
    }

    static func selectableCollectionViewCell(application: DownApplicationType) -> ViewStyling {
        return ViewStyling {
            let view = UIView()
            view.backgroundColor = Stylesheet.Colors
                .primaryColor(for: application)
                .withAlphaComponent(0.3)
            $0.selectedBackgroundView = view
        }
    }
}
