//
//  ApplicationHeaderView.swift
//  Down
//
//  Created by Ruud Puts on 11/07/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import UIKit
import DownKit

class ApplicationHeaderView: UIView {
    @IBOutlet weak var imageView: UIImageView?
    @IBOutlet weak var button: UIButton?

    func set(application: DownApplication) {
        imageView?.image = AssetProvider.icon(for: application.type)
    }
}
