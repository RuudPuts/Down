//
//  ImageViewStyle.swift
//  Down
//
//  Created by Ruud Puts on 23/12/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import DownKit

extension ViewStyling where ViewType: UIImageView {
    static func overlayedImageView(color: UIColor) -> ViewStyling {
        return ViewStyling {
            $0.image = $0.image?.withRenderingMode(.alwaysTemplate)
            $0.tintColor = color
        }
    }

    static func imageView(for type: DownApplicationType) -> ViewStyling {
        return ViewStyling {
            let overlayColor = Stylesheet.Colors.primaryColor(for: type)
            $0.style(as: .overlayedImageView(color: overlayColor))
        }
    }
}
