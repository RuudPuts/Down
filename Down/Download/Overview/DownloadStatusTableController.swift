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

class DownloadStatusTableController: NSObject, Depending {
    typealias Dependencies = DownloadApplicationDependency
    let dependencies: Dependencies

    private weak var tableView: UITableView?
    fileprivate var datasource = [TableSectionData<DownloadItem>]() {
        didSet {
            tableView?.reloadData()
        }
    }

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }

    func prepare(tableView: UITableView) {
        tableView.registerCell(nibName: DownloadItemCell.reuseIdentifier)
        tableView.registerHeaderFooter(nibName: TableHeaderView.reuseIdentifier)

        self.tableView = tableView
    }
}

extension Reactive where Base: DownloadStatusTableController {
    var datasource: Binder<[TableSectionData<DownloadItem>]> {
        return Binder(base) { tableController, datasource in
            tableController.datasource = datasource
        }
    }
}

extension DownloadStatusTableController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return datasource.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource[section].items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DownloadItemCell.reuseIdentifier, for: indexPath)

        guard let itemCell = cell as? DownloadItemCell else {
            return cell
        }

        let item = datasource[indexPath.section].items[indexPath.row]
        let applicationType = dependencies.downloadApplication.downType

        if let queueItem = item as? DownloadQueueItem {
            itemCell.viewModel = DownloadItemCellModel(queueItem: queueItem, applicationType: applicationType)
        }
        else if let historyItem = item as? DownloadHistoryItem {
            itemCell.viewModel = DownloadItemCellModel(historyItem: historyItem, applicationType: applicationType)
        }

        return cell
    }
}

extension DownloadStatusTableController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: TableHeaderView.reuseIdentifier)
        guard let headerView = view as? TableHeaderView else {
            return nil
        }

        let sectionData = datasource[section]
        headerView.viewModel = TableHeaderViewModel(title: sectionData.header, icon: sectionData.icon)

        return view
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.style(as: .selectableCell(application: dependencies.downloadApplication.downType))
    }
}
