//
//  DvrAiringSoonCell.swift
//  Down
//
//  Created by Ruud Puts on 18/12/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import UIKit
import DownKit
import Kingfisher

class DvrAiringSoonCell: UITableViewCell {
    @IBOutlet weak var bannerImageView: UIImageView!
    @IBOutlet weak var showLabel: UILabel!
    @IBOutlet weak var seasonEpisodeLabel: UILabel!
    @IBOutlet weak var airingOnLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        applyStyling()
    }

    private func applyStyling() {
        style(as: .defaultCell)
        backgroundColor = .clear

        showLabel?.style(as: .titleLabel)
        seasonEpisodeLabel?.style(as: .detailLabel)
        airingOnLabel?.style(as: .detailLabel)
    }
}

extension DvrAiringSoonCell {
    func configure(with episode: DvrAiringSoonViewModel.RefinedEpisode) {
        bannerImageView.kf.setImage(with: episode.bannerUrl)

        showLabel.text = episode.showName
        seasonEpisodeLabel.text = episode.seasonAndEpisode
        airingOnLabel.text = episode.airingOn
    }
}
