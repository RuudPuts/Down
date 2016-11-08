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
        for subview: UIView in self.subviews as [UIView] {
            subview.removeFromSuperview()
        }
    }
    
    // MARK: - Constraints
    
    var leftConstraint: NSLayoutConstraint? {
        get {
            return findParentConstraint(.leading)
        }
    }
    
    
    var rightConstraint: NSLayoutConstraint? {
        get {
            return findParentConstraint(.trailing)
        }
    }
    
    
    var topConstraint: NSLayoutConstraint? {
        get {
            return findParentConstraint(.top)
        }
    }
    
    var bottomConstraint: NSLayoutConstraint? {
        get {
            return findParentConstraint(.bottom)
        }
    }
    
    // MARK: - Constraints (Width/Height)
    
    var widthConstraint: NSLayoutConstraint? {
        get {
            return findConstraint(.width)
        }
    }
    
    var heightConstraint: NSLayoutConstraint? {
        get {
            return findConstraint(.height)
        }
    }
    
    fileprivate func findConstraint(_ attribute: NSLayoutAttribute) -> NSLayoutConstraint? {
        var foundConstraint: NSLayoutConstraint?
        
        if attribute == .width || attribute == .height {
            for constraint: NSLayoutConstraint in self.constraints {
                if constraint.isMember(of: NSLayoutConstraint.self) && constraint.firstAttribute == attribute {
                    foundConstraint = constraint
                }
            }
        }
        
        return foundConstraint
    }
    
    // MARK: - Constraints (Center)
    
    var horizontalCenterConstraint: NSLayoutConstraint? {
        get {
            return findParentConstraint(.centerX)
        }
    }
    
    var verticalCenterConstraint: NSLayoutConstraint? {
        get {
            return findParentConstraint(.centerY)
        }
    }
    
    fileprivate func findParentConstraint(_ attribute: NSLayoutAttribute) -> NSLayoutConstraint? {
        var foundConstraint: NSLayoutConstraint?
        
        for constraint: NSLayoutConstraint in self.superview!.constraints {
            if ((constraint.firstItem as! UIView == self && constraint.firstAttribute == attribute) ||
                (constraint.secondItem as! UIView? == self && constraint.secondAttribute == attribute)) &&
                constraint.isMember(of: NSLayoutConstraint.self) {
                    foundConstraint = constraint
            }
        }
        
        return foundConstraint
    }
}
