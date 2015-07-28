//
//  DownMoreCell.swift
//  Down
//
//  Created by Ruud Puts on 13/04/15.
//  Copyright (c) 2015 Ruud Puts. All rights reserved.
//

import UIKit

class DownMoreCell: UITableViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var label: UILabel!
    
    override func setHighlighted(highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        
        if (highlighted) {
            self.containerView.backgroundColor = UIColor.downSabNZBdColor().colorWithAlphaComponent(0.15)
        }
        else {
            self.containerView.backgroundColor = UIColor.downLightGreyColor()
        }
    }
    
}