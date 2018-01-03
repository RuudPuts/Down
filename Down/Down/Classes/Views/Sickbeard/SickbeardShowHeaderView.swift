//
//  SickbeardShowHeaderView.swift
//  Down
//
//  Created by Ruud Puts on 22/08/16.
//  Copyright © 2016 Ruud Puts. All rights reserved.
//

import UIKit
import DownKit
import Rswift

class SickbeardShowHeaderView: UIView {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var qualityLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var airsLabel: UILabel!
    @IBOutlet weak var episodesAvailbleLabel: UILabel!
    
    @IBOutlet weak var posterView: UIImageView!
    
    var show: SickbeardShow? {
        didSet {
            posterView.image = show!.posterThumbnail ?? R.image.sickbeardDefaultPoster()
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
        switch quality { // TODO: Add colors for other qualities
        case .wildcard: return .downLightGrayColor()
        case .custom: return .clear
        case .hd: return .clear
        case .hd1080p: return .downCouchPotatoDarkColor()
        case .hd720p: return .downSickbeardDarkColor()
        case .sd: return .clear
        }
    }
    
}
