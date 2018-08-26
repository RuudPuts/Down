//
//  UILabelStyle.swift
//  Down
//
//  Created by Ruud Puts on 14/08/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import UIKit

extension ViewStyling where ViewType == UILabel {
    static var headerLabel = ViewStyling {
        $0.textColor = .white
        $0.font = Stylesheet.Fonts.headerFont
    }

    static var titleLabel = ViewStyling {
        $0.textColor = .white
        $0.font = Stylesheet.Fonts.titleFont
    }

    static var detailLabel = ViewStyling {
        $0.textColor = .white
        $0.font = Stylesheet.Fonts.detailFont
    }
}
