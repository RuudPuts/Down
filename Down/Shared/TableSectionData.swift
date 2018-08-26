//
//  TableSectionData.swift
//  Down
//
//  Created by Ruud Puts on 26/08/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import RxDataSources
import DownKit

struct TableSectionData: SectionModelType {
    typealias Item = DownloadItem

    var header: String
    var icon: UIImage?

    var items: [Item]

    init(header: String, icon: UIImage?, items: [Item]) {
        self.header = header
        self.icon = icon
        self.items = items
    }

    init(original: TableSectionData, items: [Item]) {
        self = original
        self.items = items
    }
}
