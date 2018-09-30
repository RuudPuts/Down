//
//  DvrShowHeaderView.swift
//  Down
//
//  Created by Ruud Puts on 28/08/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import UIKit
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
            bannerImageView.image = viewModel?.banner
            posterImageView.image = viewModel?.poster
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
    let banner: UIImage?
    let poster: UIImage?
    let name: String
    let network: String
    let airTime: String
    let quality: Quality
    let status: DvrShowStatus

    var airingOn: String {
        return "Airs \(airTime) on \(network)"
    }

    init(show: DvrShow) {
        banner = AssetStorage.banner(for: show)
        poster = AssetStorage.poster(for: show)
        name = show.name
        network = show.network
        airTime = show.airTime
        quality = show.quality
        status = show.status
    }
}
