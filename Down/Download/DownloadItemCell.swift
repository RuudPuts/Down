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
        }
    }
    
    func setViewModel(_ viewModel: DownloadItemCellModel) -> DownloadItemCell {
        self.viewModel = viewModel
        return self
    }
}

struct DownloadItemCellModel {
    let text: String

    //! Not too happy about this, but is nessecary for DownloadViewController to make a Model
    // Also starts the DownKit dependency
    init(item: DownloadItem) {
        if let episode = item.dvrEpisode {
            text = "\(episode.show.name) - S\(episode.season.identifier)E\(episode.identifier) - \(episode.name)"
        }
        else {
            text = item.name
        }
    }
}
