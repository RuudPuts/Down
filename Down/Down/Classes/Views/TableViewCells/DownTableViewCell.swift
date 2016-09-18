//
//  DownCell.swift
//  Down
//
//  Created by Ruud Puts on 18/09/15.
//  Copyright (c) 2015 Ruud Puts. All rights reserved.
//

import UIKit
import DownKit

class DownTableViewCell: UITableViewCell, UITextFieldDelegate {
    
    @IBOutlet weak var containerView: UIView?
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView?
    @IBOutlet weak var textField: UITextField?
    
    var cellType: DownApplication = .SabNZBd
    var cellColor = UIColor.downSabNZBdColor()
    
    var delegate: DownTableViewCellDegate?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = UIColor.clearColor()
        textLabel?.textColor = UIColor.downSabNZBdColor()
        textLabel?.font = UIFont(name: "OpenSans", size: 14)
        detailTextLabel?.textColor = UIColor.whiteColor()
        detailTextLabel?.font = UIFont(name: "OpenSans-Light", size: 14)
        selectionStyle = .None
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        activityIndicator?.startAnimating()
        
        textLabel?.textColor = cellColor
        activityIndicator?.color = cellColor
        textField?.delegate = self
        textField?.layer.cornerRadius = 5
        textField?.layer.borderWidth = 0.7
        textField?.layer.borderColor = cellColor.CGColor
    }
    
    override func setHighlighted(highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        
        if highlighted {
            containerView?.backgroundColor = highlighted ? highlightedBackgroundColor.colorWithAlphaComponent(0.15) : .downLightGrayColor()
        }
        else {
            containerView?.backgroundColor = .downLightGrayColor()
        }
    }
    
    private var highlightedBackgroundColor: UIColor {
        var color: UIColor
        
        switch cellType {
        case .SabNZBd:
            color = .downSabNZBdDarkColor()
            break
        case .Sickbeard:
            color = .downSickbeardDarkColor()
            break
        case .CouchPotato:
            color = .downCouchPotatoDarkColor()
            break
        case .Down:
            color = .downRedColor()
            break
        }
        
        return color
    }
    
    func setCellType(type: DownApplication) {
        cellType = type
        
        switch cellType {
        case .SabNZBd:
            cellColor = .downSabNZBdColor()
            break
        case .Sickbeard:
            cellColor = .downSickbeardColor()
            break
        case .CouchPotato:
            cellColor = .downCouchPotatoColor()
            break
        case .Down:
            cellColor = .downRedColor()
            break
        }
    }
    
    var textFieldPlaceholder: String? {
        get {
            return textField?.attributedPlaceholder?.string
        }
        set {
            if let placeholder = newValue {
                let color = UIColor.whiteColor().colorWithAlphaComponent(0.5)
                textField?.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSForegroundColorAttributeName: color])
            }
            else {
                textField?.attributedPlaceholder = nil
            }
        }
    }
    
    func showActivityIndicator() {
//        if let indicator = activityIndicator {
//            if let constraint = indicator.rightConstraint {
//                constraint.active = true
//            }
//            else if let superview = indicator.superview {
//                // I don't know, for some reason the right constraint is gone after hideActivityIndicator has disabled it...
//                let views = ["indicator": indicator, "cell": superview]
//                let options = NSLayoutFormatOptions(rawValue: 0)
//                let constraints = NSLayoutConstraint.constraintsWithVisualFormat("H:[indicator]-(8)-[cell]", options: options, metrics: nil, views: views)
//                superview.addConstraints(constraints)
//            }
//        }
        
        // Yes I know, this is ugly. I wanted something like the part above, or rather what is commented in hideActivityIndicator
        // But for some reason things where being bitchy, and it didn't work.. So I made this 'other solution'
        activityIndicator?.leftConstraint?.constant = 8
        activityIndicator?.widthConstraint?.constant = 20
        
        
        activityIndicator?.hidden = false
        layoutIfNeeded()
    }
    
    func hideActivityIndicator() {
        // Some day, in a better world, this will work..
//        activityIndicator?.rightConstraint?.active = false
        
        // Untill then..
        activityIndicator?.leftConstraint?.constant = 0
        activityIndicator?.widthConstraint?.constant = 0
        
        activityIndicator?.hidden = true
        layoutIfNeeded()
    }
    
    // MARK - TextField
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    @IBAction func textFieldDidChangeText(textField: UITextField) {
        delegate?.downTableViewCell(self, didChangeText: textField.text ?? "")
    }
}

protocol DownTableViewCellDegate {
    
    func downTableViewCell(cell: DownTableViewCell, didChangeText text: String)
    
}

extension UIView {
    
    func layoutIfNeeded(animated: Bool) {
        if animated {
            UIView.animateWithDuration(0.3, animations: {
                self.layoutIfNeeded()
            })
        }
        else {
            layoutIfNeeded()
        }
    }
    
}