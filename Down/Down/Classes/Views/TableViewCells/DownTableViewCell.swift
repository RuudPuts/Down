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
        
        switch cellType {
        case .SabNZBd:
            activityIndicator?.color = .downSabNZBdColor()
            break
        case .Sickbeard:
            activityIndicator?.color = .downSickbeardColor()
            break
        case .CouchPotato:
            activityIndicator?.color = .downCouchPotatoColor()
            break
        }
    }
    
}