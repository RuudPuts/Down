//
//  UITableViewView.swift
//  Down
//
//  Created by Ruud Puts on 17/07/2018.
//  Copyright © 2018 Ruud Puts. All rights reserved.
//

import UIKit

extension ViewStyling where ViewType == UITableView {
    static var defaultTableView = ViewStyling {
        $0.backgroundColor = .clear
        $0.sectionHeaderHeight = 40
        $0.separatorColor = Stylesheet.Colors.Backgrounds.lightBlue
        $0.tableFooterView = UIView()
    }

    static var cardTableView = ViewStyling {
        $0.style(as: .defaultTableView)
        $0.separatorStyle = .none
    }
}
