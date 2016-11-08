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
    @IBOutlet weak var airsLabel: UILabel!
    @IBOutlet weak var episodesAvailbleLabel: UILabel!
    
    @IBOutlet weak var posterView: UIImageView!
    
    var show: SickbeardShow? {
        didSet {
            posterView.image = show!.posterThumbnail;
            nameLabel.text = show!.name
            airsLabel.text = show!.airs.length > 0 ? "\(show!.airs) on \(show!.network)" : show!.network
            statusLabel.text = show!.status.rawValue
            qualityLabel.text = show!.quality.rawValue
            qualityLabel.backgroundColor = colorForQuality(show!.quality)
        }
    }
    
    override func awakeAfter(using aDecoder: NSCoder) -> Any? {
        self.backgroundColor = .clear
        
        return self
    }
    
    func colorForQuality(_ quality: SickbeardShow.SickbeardShowQuality) -> UIColor {
        switch quality { // WARN: Add colors for other qualities
        case .Wildcard: return .downLightGrayColor()
        case .Custom: return .clear
        case .HD: return .clear
        case .HD1080p: return .downCouchPotatoDarkColor()
        case .HD720p: return .downSickbeardDarkColor()
        case .SD: return .clear
        }
    }
    
}
