//
//  TableHeaderViewStyle.swift
//  Down
//
//  Created by Ruud Puts on 15/08/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import UIKit

extension ViewStyling where ViewType == TableHeaderView {
    static var defaultTableHeaderView = ViewStyling {
        $0.backgroundView?.style(as: .backgroundView)
        $0.label.style(as: .headerLabel)
        $0.imageView.topConstraint?.constant = 2
    }
}
