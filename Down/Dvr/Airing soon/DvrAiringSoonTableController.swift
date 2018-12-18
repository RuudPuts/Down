//
//  DvrAiringSoonTableController.swift
//  Down
//
//  Created by Ruud Puts on 18/12/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import UIKit
import DownKit
import RxSwift
import RxCocoa
import RxDataSources

class DvrAiringSoonTableController: NSObject, Depending {
    typealias Dependencies = DvrApplicationDependency
    let dependencies: Dependencies

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }

    func prepare(_ tableView: UITableView) {
        tableView.registerCell(nibName: DvrAiringSoonCell.reuseIdentifier)
        tableView.registerHeaderFooter(nibName: TableHeaderView.reuseIdentifier)

        tableView.delegate = self
    }

    typealias RxDataSourceType = RxTableViewSectionedReloadDataSource<TableSectionData<DvrAiringSoonViewModel.RefinedEpisode>>
    lazy var dataSource = RxDataSourceType(configureCell: { (_, tableView, indexPath, item) -> UITableViewCell in
        let cell = tableView.dequeueReusableCell(withIdentifier: DvrAiringSoonCell.reuseIdentifier, for: indexPath)

        guard let itemCell = cell as? DvrAiringSoonCell else {
            return cell
        }

        itemCell.configure(with: item)

        return cell
    })
}

extension DvrAiringSoonTableController: UITableViewDelegate {
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
        cell.style(as: .selectableCell(application: dependencies.dvrApplication.downType))
    }
}
