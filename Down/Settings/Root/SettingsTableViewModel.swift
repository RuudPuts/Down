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
    typealias Dependencies = ApplicationPersistenceDependency
    let dependencies: Dependencies
    
    let viewModel: SettingsViewModel
    let datasource: [SettingsSectionModel]
    var router: Router?

    init(dependencies: Dependencies, viewModel: SettingsViewModel, router: Router?) {
        self.dependencies = dependencies
        self.viewModel = viewModel
        self.datasource = viewModel.datasource
        self.router = router
    }

    func prepare(tableView: UITableView) {
        tableView.registerCell(nibName: SettingsApplicationCell.reuseIdentifier)
        tableView.registerHeaderFooter(nibName: TableHeaderView.reuseIdentifier)
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

        let type = datasource[section].applicationType
        headerView.viewModel = TableHeaderViewModel(title: viewModel.title(for: type),
                                                    icon: viewModel.icon(for: type))

        return view
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let applicationType = datasource[indexPath.section].applications[indexPath.row]
        let application = dependencies.persistence.load(type: applicationType) ?? makeApplication(ofType: applicationType)

        router?.settingsRouter.showSettings(for: application)
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let type = datasource[indexPath.section].applications[indexPath.row]
        cell.style(as: .selectableCell(application: type))
    }

    private func makeApplication(ofType type: DownApplicationType) -> ApiApplication {
        switch type {
        case .sabnzbd: return DownloadApplication(type: .sabnzbd, host: "", apiKey: "")
        case .sickbeard: return DvrApplication(type: .sickbeard, host: "", apiKey: "")
        case .couchpotato: return DmrApplication(type: .couchpotato, host: "", apiKey: "")
        }
    }
}
