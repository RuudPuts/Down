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
import RxDataSources

class SectionedTableController<ItemType>: NSObject, UITableViewDelegate {
    typealias SectionDataType = TableSectionData<ItemType>
    typealias RxDataSourceType = RxTableViewSectionedReloadDataSource<SectionDataType>

    let application: ApiApplication

    init(application: ApiApplication) {
        self.application = application
    }

    func prepare(_ tableView: UITableView) {
        tableView.registerHeaderFooter(nibName: TableHeaderView.reuseIdentifier)

        tableView.delegate = self
    }

    lazy var dataSource = RxDataSourceType(configureCell: { (_, tableView, indexPath, item) -> UITableViewCell in
        return self.cell(forItem: item, atIndexPath: indexPath, inTableView: tableView)
    })

    func cell(forItem item: ItemType, atIndexPath indexPath: IndexPath, inTableView tableView: UITableView) -> UITableViewCell {
        fatalError("Subclasses should implement 'func cell(forItem item:atIndexPath:tableView:)'")
    }

    // MAKR: UITableViewDelegate

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return dataSource[section].items.isEmpty ? .leastNonzeroMagnitude : tableView.sectionHeaderHeight
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionData = dataSource[section]
        guard !sectionData.items.isEmpty else {
            return nil
        }

        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: TableHeaderView.reuseIdentifier)
        guard let headerView = view as? TableHeaderView else {
            return nil
        }

        headerView.viewModel = TableHeaderViewModel(title: sectionData.header, icon: sectionData.icon)

        return view
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.style(as: .selectableCell(application: application.downType))
    }
}
