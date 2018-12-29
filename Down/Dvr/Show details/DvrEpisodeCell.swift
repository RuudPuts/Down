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
    @IBOutlet weak var plotContainer: UIStackView!
    @IBOutlet weak var plotActivityView: ActivityView!
    @IBOutlet weak var plotLabel: UILabel!
    @IBOutlet weak var airLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var statusButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()

        plotContainer.isHidden = true
        statusButton.isHidden = true

        applyStyling()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        plotContainer.isHidden = !selected
        statusButton.isHidden = !selected
    }

    private func applyStyling() {
        style(as: .defaultCell)
        selectionStyle = .none
        
        nameLabel.style(as: .titleLabel)
        airLabel.style(as: .detailLabel)
        statusLabel.style(as: .detailLabel)

//        plotActivityView.configure(with: <#T##String#>, application: <#T##DownApplicationType#>)
//        plotActivityView.style(as: .activityView)
        plotLabel.style(as: .detailLabel)
        statusButton.style(as: .successButton)
        statusButton.setTitle("Set status", for: .normal)
    }
}

extension DvrEpisodeCell {
    func configure(with episode: DvrShowDetailsViewModel.RefinedEpisode) {
        nameLabel.text = episode.title
        airLabel.text = episode.airingOn
        statusLabel.text = episode.statusDescription

        statusLabel.style(as: .episodeStatusLabel(episode.status))

        plotLabel.text = episode.plot

        let plotAvailable = plotLabel.text != nil
        plotLabel.isHidden = !plotAvailable
        plotActivityView.isHidden = plotAvailable
    }
}
