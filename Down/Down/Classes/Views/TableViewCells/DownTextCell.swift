//
//  DownTextCell.swift
//  Down
//
//  Created by Ruud Puts on 13/04/15.
//  Copyright (c) 2015 Ruud Puts. All rights reserved.
//

import UIKit

class DownTextCell: UITableViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak private var cheveronView: UIImageView!
    
    enum CheveronType {
        case SabNZBd
        case Sickbeard
        case CouchPotato
    }
    
    override func setHighlighted(highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        
        if (highlighted) {
            containerView.backgroundColor = UIColor.downSabNZBdColor().colorWithAlphaComponent(0.15)
        }
        else {
            containerView.backgroundColor = UIColor.downLightGreyColor()
        }
    }
    
    func setCheveronType(type: CheveronType) {
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
        }
        
        
    }
    
}