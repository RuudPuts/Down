//
//  DownTextCell.swift
//  Down
//
//  Created by Ruud Puts on 13/04/15.
//  Copyright (c) 2015 Ruud Puts. All rights reserved.
//

import UIKit
import DownKit

class DownTextCell: DownTableViewCell {

    @IBOutlet weak private var cheveronView: UIImageView!
    @IBOutlet weak var labelToCellConstraint: NSLayoutConstraint!
    @IBOutlet weak var labelToCheveronConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var colorView: UIView!
    
    override func setCellType(type: DownApplication) {
        super.setCellType(type)
        switch type {
        case .SabNZBd:
            cheveronView.image = UIImage(named: "sabnzbd-cheveron")
            break
        case .Sickbeard:
            cheveronView.image = UIImage(named: "sickbeard-cheveron")
            break
        case .CouchPotato:
            cheveronView.image = UIImage(named: "couchpotato-cheveron")
            break
        case .Down:
            // TODO: Create asset
            cheveronView.image = UIImage(named: "down-cheveron")
            break
        }
    }
    
    var cheveronHidden: Bool {
        get {
            return cheveronView.hidden
        }
        set {
            cheveronView.hidden = newValue
            
            // TODO: Fix this so the label actually becomes larger
            labelToCheveronConstraint.active = !newValue
            labelToCellConstraint.active = newValue
            containerView?.layoutIfNeeded()
        }
    }
    
    var colorViewHidden: Bool {
        get {
            return colorView.widthConstraint?.constant == 0
        }
        set {
            colorView.widthConstraint?.constant = 4
        }
    }
    
}