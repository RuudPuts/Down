//
//  SettingsTableViewModel.swift
//  Down
//
//  Created by Ruud Puts on 02/10/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import DownKit
import RxSwift
import RxCocoa

struct SettingsSectionModel {
    let applicationType: ApiApplicationType
    let title: String
    let applications: [DownApplicationType]
}

class SettingsTableViewModel: NSObject {
    private let viewModel: SettingsViewModel

    private weak var tableView: UITableView?
    fileprivate var datasource = [SettingsSectionModel]() {
        didSet {
            tableView?.reloadData()
        }
    }

    init(viewModel: SettingsViewModel) {
        self.viewModel = viewModel
    }

    func prepare(_ tableView: UITableView) {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.registerCell(nibName: SettingsApplicationCell.reuseIdentifier)
        tableView.registerHeaderFooter(nibName: TableHeaderView.reuseIdentifier)

        self.tableView = tableView
    }
}

extension Reactive where Base: SettingsTableViewModel {
    var datasource: Binder<[SettingsSectionModel]> {
        return Binder(base) { tableModel, datasource in
            tableModel.datasource = datasource
        }
    }
}

extension SettingsTableViewModel: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return datasource.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource[section].applications.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SettingsApplicationCell.reuseIdentifier,
                                                 for: indexPath)
        guard let applicationCell = cell as? SettingsApplicationCell else {
            return cell
        }

        let application = datasource[indexPath.section].applications[indexPath.row]
        applicationCell.viewModel = makeCellModel(for: application)

        return applicationCell
    }

    private func makeCellModel(for applicationType: DownApplicationType) -> SettingsApplicationCellModel {
        return SettingsApplicationCellModel(applicationType: applicationType)
    }
}

extension SettingsTableViewModel: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: TableHeaderView.reuseIdentifier)
        guard let headerView = view as? TableHeaderView else {
            return nil
        }

        headerView.configure(with: datasource[section].title)

        return view
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let type = datasource[indexPath.section].applications[indexPath.row]
        cell.style(as: .selectableTableViewCell(application: type))
    }
}
