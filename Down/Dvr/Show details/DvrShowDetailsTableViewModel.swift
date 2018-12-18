//
//  DvrShowDetailsTableViewModel.swift
//  Down
//
//  Created by Ruud Puts on 09/09/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import DownKit
import RxSwift
import RxCocoa

class DvrShowDetailsTableViewModel: NSObject, Depending {
    typealias Dependencies = DvrApplicationDependency
    let dependencies: Dependencies

    var refinedShow: DvrShowDetailsViewModel.RefinedShow?

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }

    func prepare(_ tableView: UITableView) {
        tableView.registerCell(nibName: DvrEpisodeCell.reuseIdentifier)
        tableView.registerHeaderFooter(nibName: TableHeaderView.reuseIdentifier)
    }
}

extension Reactive where Base: DvrShowDetailsTableViewModel {
    var refinedShow: Binder<DvrShowDetailsViewModel.RefinedShow?> {
        return Binder(base) { tableViewModel, refinedShow in
            tableViewModel.refinedShow = refinedShow
        }
    }
}

extension DvrShowDetailsTableViewModel: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return refinedShow?.seasons.count ?? 0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return refinedShow?.seasons[section].episodes.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DvrEpisodeCell.reuseIdentifier, for: indexPath)
        guard let episodeCell = cell as? DvrEpisodeCell,
              let episode = refinedShow?.seasons[indexPath.section].episodes[indexPath.row] else {
            return cell
        }

        episodeCell.configure(with: episode)

        return cell
    }
}

extension DvrShowDetailsTableViewModel: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: TableHeaderView.reuseIdentifier)
        guard let headerView = view as? TableHeaderView,
              let season = refinedShow?.seasons[section] else {
            return nil
        }

        headerView.viewModel = TableHeaderViewModel(title: season.title, icon: nil)

        return view
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.style(as: .defaultCell)
        cell.style(as: .selectableCell(application: dependencies.dvrApplication.downType))
    }
}
