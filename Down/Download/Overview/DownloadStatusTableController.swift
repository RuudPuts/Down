//
//  DownloadStatusTableController.swift
//  Down
//
//  Created by Ruud Puts on 18/11/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import UIKit
import DownKit
import RxSwift
import RxCocoa

class DownloadStatusTableController: SectionedTableController<DownloadItem>, Depending {
    typealias Dependencies = DownloadApplicationDependency
    let dependencies: Dependencies

    init(dependencies: Dependencies) {
        self.dependencies = dependencies

        super.init(application: dependencies.downloadApplication)
    }

    override func prepare(_ tableView: UITableView) {
        super.prepare(tableView)

        tableView.registerCell(nibName: DownloadItemCell.reuseIdentifier)
    }

    override func cell(forItem item: DownloadItem, atIndexPath indexPath: IndexPath, inTableView tableView: UITableView) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DownloadItemCell.reuseIdentifier, for: indexPath)

        guard let itemCell = cell as? DownloadItemCell else {
            return cell
        }

        itemCell.configure(with: self.dependencies.downloadApplication, andItem: item)

        return cell
    }
}
