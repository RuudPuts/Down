//
//  SickbeardHeaderView.swift
//  Down
//
//  Created by Ruud Puts on 15/03/15.
//  Copyright (c) 2015 Ruud Puts. All rights reserved.
//

import UIKit

class SickbeardHeaderView: UIView {
    
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        textLabel.textColor = .downSickbeardColor()
        imageView.image = UIImage(named: "sickbeard-airingtoday")
    }
    
}
