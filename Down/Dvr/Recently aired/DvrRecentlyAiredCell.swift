//
//  DvrRecentlyAiredCell.swift
//  Down
//
//  Created by Ruud Puts on 18/12/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import UIKit
import DownKit
import Kingfisher

class DvrRecentlyAiredCell: UITableViewCell {
    @IBOutlet weak var bannerImageView: UIImageView!
    @IBOutlet weak var showLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var airedOnLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        applyStyling()
    }

    private func applyStyling() {
        style(as: .defaultTableViewCell)

        showLabel?.style(as: .titleLabel)
        titleLabel?.style(as: .detailLabel)
        airedOnLabel?.style(as: .detailLabel)
        statusLabel?.style(as: .detailLabel)
    }
}

extension DvrRecentlyAiredCell {
    func configure(with episode: DvrRecentlyAiredViewModel.RefinedEpisode) {
        bannerImageView.kf.setImage(with: episode.bannerUrl)

        showLabel.text = episode.showAndIdentifier
        titleLabel.text = episode.title
        airedOnLabel.text = episode.airedOn
        
        statusLabel.text = episode.status.displayString
        statusLabel.isHidden = episode.status == .unknown
        statusLabel.style(as: .episodeStatusLabel(episode.status))
    }
}
