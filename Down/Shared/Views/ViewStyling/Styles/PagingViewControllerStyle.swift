//
//  PagingViewController.swift
//  Down
//
//  Created by Ruud Puts on 16/12/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import Parchment
import DownKit

extension ViewStyling where ViewType: PagingViewController<PagingIndexItem> {
    static func pagingViewController(for applicationType: DownApplicationType) -> ViewStyling {
        return ViewStyling {
            $0.menuBackgroundColor = .clear
            $0.borderOptions = .hidden

            $0.indicatorColor = Stylesheet.Colors.primaryColor(for: applicationType)

            let itemWidth = $0.view.bounds.width / CGFloat($0.children.count)
            $0.menuItemSize = .sizeToFit(minWidth: itemWidth, height: 40)

            $0.font = Stylesheet.Fonts.titleFont
            $0.textColor = Stylesheet.Colors.white

            $0.selectedFont = Stylesheet.Fonts.titleFont
            $0.selectedTextColor = Stylesheet.Colors.white
        }
    }
}
