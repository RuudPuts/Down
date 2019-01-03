//
//  UIBarButtonItemExtensions.swift
//  Down
//
//  Created by Ruud Puts on 03/01/2019.
//  Copyright © 2019 Mobile Sorcery. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    static func contextButton(target: Any? = nil, action: Selector? = nil) -> UIBarButtonItem {
        return UIBarButtonItem(image: R.image.icon_context()?.withRenderingMode(.alwaysTemplate),
                               style: .done,
                               target: target,
                               action: action)
    }
}
