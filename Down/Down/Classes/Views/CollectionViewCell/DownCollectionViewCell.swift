//
//  DownCell.swift
//  Down
//
//  Created by Ruud Puts on 18/09/15.
//  Copyright (c) 2015 Ruud Puts. All rights reserved.
//

import UIKit
import DownKit

class DownCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var label: UILabel!
    
    var cellType: DownApplication = .SabNZBd
    var cellColor = UIColor.downSabNZBdColor()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        label?.textColor = cellColor
    }
    
    func setCellType(_ type: DownApplication) {
        cellType = type
        cellColor = type.color
    }
}
