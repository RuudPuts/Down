//
//  UIBarButtonItemStyles.swift
//  Down
//
//  Created by Ruud Puts on 03/01/2019.
//  Copyright © 2019 Mobile Sorcery. All rights reserved.
//

import UIKit
import DownKit

extension ViewStyling where ViewType == UIBarButtonItem {
    static func barButtonItem(_ type: DownApplicationType) -> ViewStyling {
        return ViewStyling {
            $0.tintColor = Stylesheet.Colors.primaryColor(for: type)
        }
    }
}
