//
//  TableHeaderView.swift
//  Down
//
//  Created by Ruud Puts on 15/08/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import UIKit

class TableHeaderView: UITableViewHeaderFooterView {
    static let identifier = String(describing: TableHeaderView.self)

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var imageView: UIImageView!

    var viewModel: TableHeaderViewModel? = nil {
        didSet {
            label.text = viewModel?.title
            imageView.image = viewModel?.icon
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundView = UIView()

        style(as: .defaultTableHeaderView)
    }
}

struct TableHeaderViewModel {
    let title: String
    let icon: UIImage?
}
