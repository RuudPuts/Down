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
    typealias Dependencies = DvrEpisodeCell.Dependencies & DvrApplicationDependency
    let dependencies: Dependencies

    var refinedShow: DvrShowDetailsViewModel.RefinedShow?

    weak var context: UIViewController?
    private weak var tableView: UITableView?

    init(dependencies: Dependencies, context: UIViewController? = nil) {
        self.dependencies = dependencies
        self.context = context
    }

    func prepare(_ tableView: UITableView) {
        tableView.registerCell(nibName: DvrEpisodeCell.reuseIdentifier)
        tableView.registerHeaderFooter(nibName: TableHeaderView.reuseIdentifier)

        self.tableView = tableView
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

        episodeCell.configure(with: episode, dependencies: dependencies, context: context)
        episodeCell.delegate = self

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
}

extension DvrShowDetailsTableViewModel: DownCellDelegate {
    func cellNeedsLayout(_ cell: UITableViewCell) {
        tableView?.animateCellResize()
    }
}
