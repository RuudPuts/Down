//
//  TableHeaderView.swift
//  Down
//
//  Created by Ruud Puts on 15/08/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import UIKit

class TableHeaderView: UITableViewHeaderFooterView {
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var imageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundView = UIView()

        style(as: .defaultTableHeaderView)
    }
}

extension TableHeaderView {
    func configure(with title: String, image: UIImage? = nil) {
        label.text = title
        imageView.image = image
        imageView.isHidden = imageView.image == nil
    }
}
