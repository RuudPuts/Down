//
//  UIView+Extensions.swift
//  Down
//
//  Created by Ruud Puts on 07/04/15.
//  Copyright (c) 2015 Ruud Puts. All rights reserved.
//

import UIKit

extension UIView {
    func removeAllSubViews() {
        for subview: UIView in self.subviews as! [UIView] {
            subview.removeFromSuperview()
        }
    }
}
