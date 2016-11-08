//
//  SickbeardShowCell.swift
//  Down
//
//  Created by Ruud Puts on 20/09/15.
//  Copyright (c) 2015 Ruud Puts. All rights reserved.
//

import UIKit
import DownKit

class SickbeardShowCell: DownCollectionViewCell {
    
    @IBOutlet weak var posterView: UIImageView!
    @IBOutlet weak var nextEpisodeLabel: UILabel!
    
    weak var show: SickbeardShow? {
        didSet {
            label?.text = show!.name
            
            if let nextEpisode = show!.nextAiringEpisode() {
                nextEpisodeLabel.isHidden = false
                nextEpisodeLabel.text = "\(nextEpisode.daysUntilAiring)"
            }
            else {
                nextEpisodeLabel.isHidden = true
            }
        }
    }
        
}
