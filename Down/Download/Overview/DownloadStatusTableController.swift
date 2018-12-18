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
import RxDataSources

class DownloadStatusTableController: NSObject, Depending {
    typealias Dependencies = DownloadApplicationDependency
    let dependencies: Dependencies

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }

    func prepare(_ tableView: UITableView) {
        tableView.registerCell(nibName: DownloadItemCell.reuseIdentifier)
        tableView.registerHeaderFooter(nibName: TableHeaderView.reuseIdentifier)
    }

    typealias RxDataSourceType = RxTableViewSectionedReloadDataSource<TableSectionData<DownloadItem>>
    lazy var dataSource = RxDataSourceType(configureCell: { (_, tableView, indexPath, item) -> UITableViewCell in
        let cell = tableView.dequeueReusableCell(withIdentifier: DownloadItemCell.reuseIdentifier, for: indexPath)

        guard let itemCell = cell as? DownloadItemCell else {
            return cell
        }

        itemCell.configure(with: self.dependencies.downloadApplication, andItem: item)

        return cell
    })
}

extension DownloadStatusTableController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: TableHeaderView.reuseIdentifier)
        guard let headerView = view as? TableHeaderView else {
            return nil
        }

        let sectionData = dataSource[section]
        headerView.viewModel = TableHeaderViewModel(title: sectionData.header, icon: sectionData.icon)

        return view
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.style(as: .selectableCell(application: dependencies.downloadApplication.downType))
    }
}
