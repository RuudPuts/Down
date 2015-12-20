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
    
    var cellType: DownApplication = .SabNZBd
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = UIColor.downLightGreyColor()
        self.textLabel?.textColor = UIColor.downSabNZBdColor()
        self.textLabel?.font = UIFont(name: "OpenSans", size: 14)
        self.detailTextLabel?.textColor = UIColor.whiteColor()
        self.detailTextLabel?.font = UIFont(name: "OpenSans-Light", size: 14)
        self.selectionStyle = .None
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        activityIndicator?.startAnimating()
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
        }
        
        return color
    }
    
    func setCellType(type: DownApplication) {
        cellType = type
        
        var cellColor: UIColor
        
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
        }
        
        self.textLabel?.textColor = cellColor
        activityIndicator?.color = cellColor
    }
    
}