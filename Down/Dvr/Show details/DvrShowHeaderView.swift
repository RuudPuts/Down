//
//  DvrShowHeaderView.swift
//  Down
//
//  Created by Ruud Puts on 28/08/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import UIKit
import Kingfisher
import DownKit
import RealmSwift

class DvrShowHeaderView: DesignableView {
    @IBOutlet weak var bannerImageView: UIImageView!
    @IBOutlet weak var bannerOverlayView: UIView!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var networkLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var qualityLabel: UILabel!

    var viewModel: DvrShowHeaderViewModel! {
        didSet {
            bannerImageView.kf.setImage(with: viewModel.bannerUrl)
            posterImageView.kf.setImage(with: viewModel.posterUrl)
            nameLabel.text = viewModel?.name
            networkLabel.text = viewModel?.airingOn
            statusLabel.text = viewModel?.status.displayString
            qualityLabel.text = viewModel?.quality.displayString

            applyStyling()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        applyStyling()
    }

    func applyStyling() {
        bannerOverlayView.style(as: .overlayView)
        nameLabel.style(as: .largeHeaderLabel)
        networkLabel.style(as: .titleLabel)
        statusLabel.style(as: .titleLabel)

        if let viewModel = viewModel {
            qualityLabel.style(as: .qualityLabel(viewModel.quality))
            statusLabel.style(as: .showStatusLabel(viewModel.status))
        }
    }
}

struct DvrShowHeaderViewModel {
    let bannerUrl: URL?
    let posterUrl: URL?
    let name: String
    let network: String
    let airTime: String
    let quality: Quality
    let status: DvrShowStatus

    var airingOn: String {
        return "Airs \(airTime) on \(network)"
    }

    init(show: DvrShow, bannerUrl: URL?, posterUrl: URL?) {
        self.bannerUrl = bannerUrl
        self.posterUrl = posterUrl
        name = show.name
        network = show.network
        airTime = show.airTime
        quality = show.quality
        status = show.status
    }
}
