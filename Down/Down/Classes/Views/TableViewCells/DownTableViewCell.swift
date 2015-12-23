//
//  DownCell.swift
//  Down
//
//  Created by Ruud Puts on 18/09/15.
//  Copyright (c) 2015 Ruud Puts. All rights reserved.
//

import UIKit
import DownKit

class DownTableViewCell: UITableViewCell {
    
    @IBOutlet weak var containerView: UIView?
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView?
    @IBOutlet weak var textField: UITextField?
    
    var cellType: DownApplication = .SabNZBd
    var cellColor = UIColor.downSabNZBdColor()
    
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
        textField?.layer.cornerRadius = 5
        textField?.layer.borderWidth = 0.7
        textField?.layer.borderColor = cellColor.CGColor
    }
    
    override func setHighlighted(highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        
        if (highlighted) {
            containerView?.backgroundColor = highlightedBackgroundColor.colorWithAlphaComponent(0.15)
        }
        else {
            containerView?.backgroundColor = .downLightGreyColor()
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
    
}