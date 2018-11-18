//
//  UIViewConstraints.swift
//  Down
//
//  Created by Ruud Puts on 07/08/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import UIKit

extension UIView {
    var widthConstraint: NSLayoutConstraint? {
        return constraint(withAttribute: .width)
    }

    var heightConstraint: NSLayoutConstraint? {
        return constraint(withAttribute: .height)
    }

    var topConstraint: NSLayoutConstraint? {
        return superview?.constraint(withAttribute: .top, toView: self)
    }

    var leadingConstraint: NSLayoutConstraint? {
        return superview?.constraint(withAttribute: .leading, toView: self)
    }

    var bottomConstraint: NSLayoutConstraint? {
        return superview?.constraint(withAttribute: .bottom, toView: self)
    }

    var trailingConstraint: NSLayoutConstraint? {
        return superview?.constraint(withAttribute: .trailing, toView: self)
    }
}

extension UIView {
    func constraintToFillParent() {
        guard let superview = superview else {
            return
        }

        translatesAutoresizingMaskIntoConstraints = false

        let views = ["view": self]
        let horizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|[view]|",
                                                                   metrics: nil,
                                                                   views: views)

        let verticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|[view]|",
                                                                 metrics: nil,
                                                                 views: views)

        superview.addConstraints(horizontalConstraints + verticalConstraints)
    }
}

private extension UIView {
    func constraint(withAttribute attribute: NSLayoutConstraint.Attribute) -> NSLayoutConstraint? {
        return constraints.first { $0.firstAttribute == attribute }
    }

    func constraint(withAttribute attribute: NSLayoutConstraint.Attribute, toView view: UIView) -> NSLayoutConstraint? {
        return constraints.first { $0.firstAttribute == attribute && $0.secondItem as? UIView == view }
    }
}
