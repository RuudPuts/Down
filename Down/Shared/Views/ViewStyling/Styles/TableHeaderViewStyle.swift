//
//  TableHeaderViewStyle.swift
//  Down
//
//  Created by Ruud Puts on 15/08/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import UIKit

extension ViewStyling where ViewType == TableHeaderView {
    static var defaultTableHeaderView = ViewStyling { (view: TableHeaderView) in
        view.label.style(as: .headerLabel)
        view.imageView.topConstraint?.constant = 2
    }
}
