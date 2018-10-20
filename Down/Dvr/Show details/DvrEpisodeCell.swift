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

    var viewModel: DvrEpisodeCellModel! {
        didSet {
            nameLabel?.text = viewModel.title
            airLabel?.text = viewModel.airingOn
            statusLabel?.text = viewModel.status.displayString

            applyStyling()
        }
    }

    func applyStyling() {
        nameLabel.style(as: .titleLabel)
        airLabel.style(as: .detailLabel)
        statusLabel.style(as: .detailLabel)

        if let viewModel = viewModel {
            statusLabel.style(as: .episodeStatusLabel(viewModel.status))
        }
    }
}

struct DvrEpisodeCellModel {
    var identifier: String
    var name: String
    var airdate: Date?
    var status: DvrEpisodeStatus

    init(episode: DvrEpisode) {
        identifier = episode.identifier
        name = episode.name
        airdate = episode.airdate
        status = episode.status
    }

    var title: String {
        return "\(identifier). \(name)"
    }

    var airingOn: String {
        return airdate?.dateString ?? R.string.localizable.dvr_episode_unaired()
    }
}
