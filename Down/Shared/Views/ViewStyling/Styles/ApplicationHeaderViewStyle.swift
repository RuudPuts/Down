//
//  ApplicationHeaderViewStyle.swift
//  Down
//
//  Created by Ruud Puts on 17/07/2018.
//  Copyright © 2018 Ruud Puts. All rights reserved.
//

import UIKit
import DownKit

extension ViewStyling where ViewType == ApplicationHeaderView {
    static func headerView(for type: DownApplicationType) -> ViewStyling {
        return ViewStyling {
            $0.imageView?.image = AssetProvider.Icon.for(type)
            $0.contextButton.style(as: .contextButton(type))
        }
    }
}
