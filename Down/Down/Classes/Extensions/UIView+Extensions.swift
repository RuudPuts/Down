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
    
    // MARK: - Constraints
    
    var widthConstraint: NSLayoutConstraint? {
        get {
            var widthConstraint: NSLayoutConstraint?
            
            for (index, constraint: NSLayoutConstraint) in enumerate(self.constraints() as! [NSLayoutConstraint]) {
                if constraint.firstAttribute == .Width && constraint.isMemberOfClass(NSLayoutConstraint) {
                    widthConstraint = constraint
                }
            }
            
            return widthConstraint
        }
    }
    
    var heightConstraint: NSLayoutConstraint? {
        get {
            var heightConstraint: NSLayoutConstraint?
            
            for (index, constraint: NSLayoutConstraint) in enumerate(self.constraints() as! [NSLayoutConstraint]) {
                if constraint.firstAttribute == .Height && constraint.isMemberOfClass(NSLayoutConstraint) {
                    heightConstraint = constraint
                }
            }

            return heightConstraint
        }
    }
    
    var horizontalCenterConstraint: NSLayoutConstraint? {
        get {
            var centerConstraint: NSLayoutConstraint?
            
            for (index, constraint: NSLayoutConstraint) in enumerate(self.superview?.constraints() as! [NSLayoutConstraint]) {
                if ((constraint.firstItem as! UIView == self && constraint.firstAttribute == .CenterX) ||
                    (constraint.secondItem as! UIView? == self && constraint.secondAttribute == .CenterX)) &&
                    constraint.isMemberOfClass(NSLayoutConstraint) {
                    centerConstraint = constraint
                }
            }
            
            return centerConstraint
        }
    }
    
}
