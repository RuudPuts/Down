//
//  AssetProvider.swift
//  Down
//
//  Created by Ruud Puts on 11/07/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import UIKit
import DownKit

class AssetProvider {
    struct Icon {
        static func `for`(_ application: DownApplicationType) -> UIImage {
            return UIImage(named: "\(application.rawValue)_icon")!
        }

        static func `for`(_ application: ApiApplicationType) -> UIImage? {
            switch application {
            case .download: return R.image.tabbar_downloads()
            case .dvr: return R.image.tabbar_shows()
            case .dmr: return R.image.tabbar_movies()
            }
        }

        static var x: UIImage? {
            return UIImage(named: "x")
        }

        static var close: UIImage? {
            return x
        }
    }
}
