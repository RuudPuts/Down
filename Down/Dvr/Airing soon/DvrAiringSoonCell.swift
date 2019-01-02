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
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var airingOnLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        applyStyling()
    }

    private func applyStyling() {
        style(as: .defaultTableViewCell)

        showLabel?.style(as: .titleLabel)
        titleLabel?.style(as: .detailLabel)
        airingOnLabel?.style(as: .detailLabel)
    }
}

extension DvrAiringSoonCell {
    func configure(with episode: DvrAiringSoonViewModel.RefinedEpisode) {
        bannerImageView.kf.setImage(with: episode.bannerUrl)

        showLabel.text = episode.showAndIdentifier
        titleLabel.text = episode.title
        airingOnLabel.text = episode.airingOn
    }
}
