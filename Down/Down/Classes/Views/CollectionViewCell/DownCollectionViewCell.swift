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
    
    private var highlightedBackgroundColor: UIColor {
        switch cellType {
        case .SabNZBd: return .downSabNZBdDarkColor()
        case .Sickbeard: return .downSickbeardDarkColor()
        case .CouchPotato: return .downCouchPotatoDarkColor()
        case .Down: return .downRedColor()
        }
    }
    
    func setCellType(type: DownApplication) {
        cellType = type
        
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
        case .Down:
            cellColor = .downRedColor()
            break
        }
    }
}