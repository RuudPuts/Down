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
import RxSwift
import RxCocoa

class DvrShowHeaderView: DesignableView {
    @IBOutlet weak var bannerImageView: UIImageView!
    @IBOutlet weak var bannerOverlayView: UIView!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var networkLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var qualityLabel: UILabel!
    @IBOutlet weak var episodesAvailableLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        applyStyling()
    }

    private func applyStyling() {
        bannerOverlayView.style(as: .overlayView)
        nameLabel.style(as: .largeHeaderLabel)
        networkLabel.style(as: .titleLabel)
        statusLabel.style(as: .titleLabel)
        episodesAvailableLabel.style(as: .detailLabel)
    }
}

extension DvrShowHeaderView {
    func configure(with show: DvrShowDetailsViewModel.RefinedShow) {
        nameLabel.text = show.name
        networkLabel.text = show.airingOn
        statusLabel.text = show.status.displayString
        qualityLabel.text = show.quality.displayString
        episodesAvailableLabel.text = show.episodesAvailable
        
        bannerImageView.kf.setImage(with: show.bannerUrl)
        posterImageView.kf.setImage(with: show.posterUrl)

        qualityLabel.style(as: .qualityLabel(show.quality))
        statusLabel.style(as: .showStatusLabel(show.status))
    }
}

extension Reactive where Base: DvrShowHeaderView {
    var refinedShow: Binder<DvrShowDetailsViewModel.RefinedShow> {
        return Binder(base) { headerView, refinedShow in
            headerView.configure(with: refinedShow)
        }
    }
}
