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

    var refinedShow: DvrShowDetailsViewModel.RefinedShow? {
        didSet {
            tableView?.reloadData()
        }
    }

    weak var context: UIViewController?
    private weak var tableView: UITableView?

    init(dependencies: Dependencies, context: UIViewController? = nil) {
        self.dependencies = dependencies
        self.context = context
    }

    func prepare(_ tableView: UITableView) {
        tableView.registerCell(nibName: DvrEpisodeCell.reuseIdentifier)
        tableView.registerHeaderFooter(nibName: DvrSeasonTableHeaderView.reuseIdentifier)

        self.tableView = tableView
    }

    func selectEpisode(_ episode: DvrEpisode) {
        guard
            let tableView = tableView,
            let seasonIndex = refinedShow?.seasons.firstIndex(where: {
                $0.identifier == episode.season.identifier
            }),
            let seasonEpisodes = episodes(for: seasonIndex) else {
            return
        }

        guard let episodeIndex = seasonEpisodes.firstIndex(where: {
            $0.identifier == episode.identifier
        }) else { return }

        let indexPath = IndexPath(row: episodeIndex, section: seasonIndex)
        tableView.selectRow(at: indexPath, animated: false, scrollPosition: .top)
        tableView.contentOffset = CGPoint(x: 0, y: tableView.contentOffset.y - 40)
        tableView.animateCellResize()
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
    private func episodes(for section: Int) -> [DvrEpisode]? {
        return refinedShow?.seasons[section].reversedEpisodes
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return refinedShow?.seasons.count ?? 0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return refinedShow?.seasons[section].episodes.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DvrEpisodeCell.reuseIdentifier, for: indexPath)
        guard let episodeCell = cell as? DvrEpisodeCell,
              let episode = episodes(for: indexPath.section)?[indexPath.row] else {
            return cell
        }

        episodeCell.configure(with: episode, dependencies: dependencies, context: context)
        episodeCell.delegate = self

        return cell
    }
}

extension DvrShowDetailsTableViewModel: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: DvrSeasonTableHeaderView.reuseIdentifier)
        guard let headerView = view as? DvrSeasonTableHeaderView,
              let season = refinedShow?.seasons[section] else {
            return nil
        }

        headerView.configure(with: season, dependencies: dependencies, context: context)

        return view
    }
}

extension DvrShowDetailsTableViewModel: DownCellDelegate {
    func cellNeedsLayout(_ cell: UITableViewCell) {
        tableView?.animateCellResize()
    }
}
