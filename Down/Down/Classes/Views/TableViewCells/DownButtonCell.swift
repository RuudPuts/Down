//
//  DownButtonCell.swift
//  Down
//
//  Created by Ruud Puts on 11/11/16.
//  Copyright © 2016 Ruud Puts. All rights reserved.
//

import DownKit

class DownButtonCell: DownIconTextCell {
    
    @IBOutlet weak var buttonView: UIView!
    
    override func setCellType(_ type: DownApplication) {
        super.setCellType(type)
        
        buttonView.backgroundColor = type.color
        iconView.image = type.icon
        
        iconView.verticalCenterConstraint?.constant = type == .sabNZBd ? 2 : 0
    }
    
}
