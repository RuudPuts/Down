//
//  DvrEpisodeCell.swift
//  Down
//
//  Created by Ruud Puts on 23/09/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import UIKit
import DownKit

class DvrEpisodeCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var airLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        applyStyling()
    }

    private func applyStyling() {
        nameLabel.style(as: .titleLabel)
        airLabel.style(as: .detailLabel)
        statusLabel.style(as: .detailLabel)
    }
}

extension DvrEpisodeCell {
    func configure(with episode: DvrShowDetailsViewModel.RefinedEpisode) {
        nameLabel.text = episode.title
        airLabel.text = episode.airingOn
        statusLabel.text = episode.status.displayString

        statusLabel.style(as: .episodeStatusLabel(episode.status))
    }
}
