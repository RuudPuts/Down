//
//  SettingsTableViewModel.swift
//  Down
//
//  Created by Ruud Puts on 02/10/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import DownKit

struct SettingsSectionModel {
    let applicationType: ApiApplicationType
    let applications: [DownApplicationType]
}

class SettingsTableViewModel: NSObject {
    let viewModel: SettingsViewModel
    let datasource: [SettingsSectionModel]

    init(viewModel: SettingsViewModel) {
        self.viewModel = viewModel
        self.datasource = viewModel.datasource
    }

    func prepare(tableView: UITableView) {
        tableView.registerCell(nibName: SettingsApplicationCell.identifier)
        tableView.registerHeaderFooter(nibName: TableHeaderView.identifier)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: SettingsApplicationCell.identifier, for: indexPath)
        guard let applicationCell = cell as? SettingsApplicationCell else {
            return cell
        }

        let application = datasource[indexPath.section].applications[indexPath.row]
        applicationCell.viewModel = makeCellModel(for: application)

        return applicationCell
    }

    private func makeCellModel(for applicationType: DownApplicationType) -> SettingsApplicationCellModel {
        let application = Down.persistence.load(type: applicationType)

        return SettingsApplicationCellModel(applicationType: applicationType, isConfigured: application != nil)
    }
}

extension SettingsTableViewModel: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: TableHeaderView.identifier)
        guard let headerView = view as? TableHeaderView else {
            return nil
        }

        let type = datasource[section].applicationType
        headerView.viewModel = TableHeaderViewModel(title: viewModel.title(for: type), icon: nil)

        return view
    }
}
