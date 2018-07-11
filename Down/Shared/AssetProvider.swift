//
//  AssetProvider.swift
//  Down
//
//  Created by Ruud Puts on 11/07/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import UIKit

class AssetProvider {
    static func icon(for application: DownApplicationType) -> UIImage? {
        return UIImage(named: "\(application.rawValue)_icon")
    }
}
