//
//  UITableViewExtensions.swift
//  Down
//
//  Created by Ruud Puts on 15/08/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import UIKit

extension UITableView {
    func registerCell(nibName nib: String) {
        register(UINib(nibName: nib, bundle: Bundle.main), forCellReuseIdentifier: nib)
    }

    func registerHeaderFooter(nibName nib: String) {
        register(UINib(nibName: nib, bundle: Bundle.main), forHeaderFooterViewReuseIdentifier: nib)
    }
}
