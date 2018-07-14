//
//  ApplicationHeaderView.swift
//  Down
//
//  Created by Ruud Puts on 11/07/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import UIKit
import DownKit

@IBDesignable
class ApplicationHeaderView: DesignableView {
    @IBOutlet weak var imageView: UIImageView?
    @IBOutlet weak var button: UIButton?

    var application: DownApplication? {
        didSet {
            guard let applicationType = application?.type else {
                imageView?.image = nil
                return
            }

            imageView?.image = AssetProvider.icons.for(applicationType)
        }
    }
}
