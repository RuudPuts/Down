//
//  AssetProvider.swift
//  Down
//
//  Created by Ruud Puts on 11/07/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import UIKit

class AssetProvider {
    struct icons {
        static func `for`(_ application: DownApplicationType) -> UIImage? {
            return UIImage(named: "\(application.rawValue)_icon")
        }

        static var x: UIImage? {
            return UIImage(named: "x")
        }

        static var close: UIImage? {
            return x
        }
    }
}
