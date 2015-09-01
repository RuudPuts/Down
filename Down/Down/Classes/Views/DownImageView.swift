//
//  DownImageView.swift
//  Down
//
//  Created by Ruud Puts on 19/08/15.
//  Copyright © 2015 Ruud Puts. All rights reserved.
//

import UIKit

class DownImageView : UIImageView {
    
    @IBInspectable
    var placeholderImage: UIImage? {
        didSet {
            if image == nil {
                image = placeholderImage
            }
        }
    }
    
    @IBInspectable
    override var image: UIImage? {
        didSet {
            if image == nil {
                image = placeholderImage
            }
        }
    }
    
}