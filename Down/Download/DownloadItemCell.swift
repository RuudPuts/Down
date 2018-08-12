//
//  DownloadItemCell.swift
//  Down
//
//  Created by Ruud Puts on 26/06/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import UIKit
import DownKit

class DownloadItemCell: UITableViewCell {
    static let identifier = String(describing: DownloadItemCell.self)
    
    var viewModel: DownloadItemCellModel! {
        didSet {
            textLabel?.text = viewModel.text
            detailTextLabel?.text = viewModel.detailText
        }
    }
    
    func setViewModel(_ viewModel: DownloadItemCellModel) -> DownloadItemCell {
        self.viewModel = viewModel
        return self
    }
}

struct DownloadItemCellModel {
    let text: String
    let detailText: String

    init(item: DownloadItem) {
        if let episode = item.dvrEpisode,
           let episodeId = Int(episode.identifier),
           let seasonId = Int(episode.season.identifier) {
            text = String(format: "%@ - S%02dE%02d - %@",
                                 episode.show.name,
                                 seasonId,
                                 episodeId,
                                 episode.name)
        }
        else {
            text = item.name
        }
        detailText = item.identifier
    }
}
