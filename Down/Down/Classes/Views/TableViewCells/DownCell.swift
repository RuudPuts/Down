//
//  DownCell.swift
//  Down
//
//  Created by Ruud Puts on 18/09/15.
//  Copyright (c) 2015 Ruud Puts. All rights reserved.
//

import UIKit
import DownKit

class DownCell: UITableViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    
    var cellType: DownApplication = .SabNZBd
    
    override func setHighlighted(highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        
        if (highlighted) {
            containerView.backgroundColor = highlightedBackgroundColor.colorWithAlphaComponent(0.15)
        }
        else {
            containerView.backgroundColor = .downLightGreyColor()
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
    }
    
}