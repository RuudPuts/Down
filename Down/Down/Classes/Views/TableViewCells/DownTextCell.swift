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
        }
        
        
    }
    
}