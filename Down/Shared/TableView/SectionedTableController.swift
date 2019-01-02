//
//  SectionedTableController.swift
//  Down
//
//  Created by Ruud Puts on 19/12/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import DownKit
import RxSwift
import RxCocoa

class SectionedTableController<ItemType>: NSObject, UITableViewDataSource, UITableViewDelegate {
    typealias SectionDataType = TableSectionData<ItemType>

    let application: ApiApplication
    var dataSource = [SectionDataType]() {
        didSet {
            tableView?.reloadData()
        }
    }

    private weak var tableView: UITableView?

    init(application: ApiApplication) {
        self.application = application
    }

    func prepare(_ tableView: UITableView) {
        tableView.registerHeaderFooter(nibName: TableHeaderView.reuseIdentifier)
        tableView.registerCell(nibName: EmptySectionCell.reuseIdentifier)

        tableView.dataSource = self
        tableView.delegate = self

        self.tableView = tableView
    }

    func cell(forItem item: ItemType, atIndexPath indexPath: IndexPath, inTableView tableView: UITableView) -> UITableViewCell {
        fatalError("Subclasses should implement 'func cell(forItem item:atIndexPath:tableView:)'")
    }

    func emptyCell(forSection section: SectionDataType, atIndexPath indexPath: IndexPath, inTableView tableView: UITableView) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: EmptySectionCell.reuseIdentifier, for: indexPath)

        guard let emptyCell = cell as? EmptySectionCell else {
            return cell
        }

        emptyCell.configure(with: section.emptyMessage ?? "")

        return emptyCell
    }

    // MAKR: UITableViewDataSource

    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let showEmptyCell = dataSource[section].emptyMessage != nil

        return max(dataSource[section].items.count, showEmptyCell ? 1 : 0)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sectionData = dataSource[indexPath.section]

        switch sectionData.cellType {
        case .regular:
            let item = dataSource[indexPath.section].items[indexPath.row]
            return cell(forItem: item, atIndexPath: indexPath, inTableView: tableView)
        case .empty:
            return emptyCell(forSection: sectionData, atIndexPath: indexPath, inTableView: tableView)
        }
    }

    // MAKR: UITableViewDelegate

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: TableHeaderView.reuseIdentifier)
        guard let headerView = view as? TableHeaderView else {
            return nil
        }

        let sectionData = dataSource[section]
        headerView.configure(with: sectionData.header, image: sectionData.icon)

        return view
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.style(as: .selectableCell(application: application.downType))
    }
}
