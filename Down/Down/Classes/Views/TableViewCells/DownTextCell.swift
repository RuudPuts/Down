//
//  DownTextCell.swift
//  Down
//
//  Created by Ruud Puts on 13/04/15.
//  Copyright (c) 2015 Ruud Puts. All rights reserved.
//

import UIKit
import DownKit
import Rswift

class DownTextCell: DownTableViewCell {

    @IBOutlet weak fileprivate var cheveronView: UIImageView?
    @IBOutlet weak var labelToCellConstraint: NSLayoutConstraint?
    @IBOutlet weak var labelToCheveronConstraint: NSLayoutConstraint?
    
    @IBOutlet weak var colorView: UIView!
    
    override func setCellType(_ type: DownApplication) {
        super.setCellType(type)
        
        guard let cheveronView = cheveronView else {
            return
        }
        
        switch type {
        case .SabNZBd:
            cheveronView.image = R.image.sabnzbdCheveron()
            break
        case .Sickbeard:
            cheveronView.image = R.image.sickbeardCheveron()
            break
        case .CouchPotato:
            // TODO: Create asset
            cheveronView.image = nil// R.image.couchpotatoCheveron()
            break
        case .Down:
            // TODO: Create asset
            cheveronView.image = nil // R.image.downCheveron()
            break
        }
    }
    
    var cheveronHidden: Bool {
        get {
            return cheveronView?.isHidden ?? true
        }
        set {
            cheveronView?.isHidden = newValue
            
            // TODO: Fix this so the label actually becomes larger
            labelToCheveronConstraint?.isActive = !newValue
            labelToCellConstraint?.isActive = newValue
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
