//
//  SickbeardShowHeaderView.swift
//  Down
//
//  Created by Ruud Puts on 22/08/16.
//  Copyright © 2016 Ruud Puts. All rights reserved.
//

import UIKit
import DownKit

class SickbeardShowHeaderView: UIView {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var qualityLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var episodesAvailbleLabel: UILabel!
    
    @IBOutlet weak var posterView: UIImageView!
    
    var show: SickbeardShow? {
        didSet {
            posterView.image = show?.posterThumbnail;
            
            nameLabel.text = show?.name
        }
    }
    
    override func awakeAfterUsingCoder(aDecoder: NSCoder) -> AnyObject? {
        self.backgroundColor = .clearColor()
        
        return self
    }
    
}