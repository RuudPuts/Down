//
//  TableSectionData.swift
//  Down
//
//  Created by Ruud Puts on 26/08/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import DownKit

struct TableSectionData<Item> {
    enum CellType {
        case empty
        case regular
    }

    var header: String
    var icon: UIImage?
    var emptyMessage: String?

    var items: [Item]

    var cellType: CellType {
        return items.isEmpty ? .empty : .regular
    }

    init(header: String, icon: UIImage?, items: [Item], emptyMessage: String? = nil) {
        self.header = header
        self.icon = icon
        self.items = items
        self.emptyMessage = emptyMessage
    }
}
