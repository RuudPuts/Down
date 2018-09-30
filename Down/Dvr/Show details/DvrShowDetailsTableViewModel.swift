//
//  DvrShowDetailsTableViewModel.swift
//  Down
//
//  Created by Ruud Puts on 09/09/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import DownKit

class DvrShowDetailsTableViewModel: NSObject {
    let show: DvrShow
    let application: DvrApplication

    init(show: DvrShow, application: DvrApplication) {
        self.show = show
        self.application = application
    }

    func prepare(tableView: UITableView) {
        tableView.registerCell(nibName: DvrEpisodeCell.identifier)
        tableView.registerHeaderFooter(nibName: TableHeaderView.identifier)
    }
}

extension DvrShowDetailsTableViewModel: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return show.seasons.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return show.sortedSeasons[section].episodes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DvrEpisodeCell.identifier, for: indexPath)
        guard let episodeCell = cell as? DvrEpisodeCell else {
            return cell
        }

        let episode = show.sortedSeasons[indexPath.section].sortedEpisodes[indexPath.row]
        episodeCell.viewModel = DvrEpisodeCellModel(episode: episode)

        return cell
    }
}

extension DvrShowDetailsTableViewModel: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: TableHeaderView.identifier)
        guard let headerView = view as? TableHeaderView else {
            return nil
        }

        let season = show.sortedSeasons[section]
        headerView.viewModel = TableHeaderViewModel(title: "Season \(season.identifier)", icon: nil)

        return view
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.style(as: .defaultCell)
        cell.style(as: .selectableCell(application: application.type))
    }
}

private extension DvrShow {
    var sortedSeasons: [DvrSeason] {
        return seasons.sorted(by: { Int($0.identifier)! > Int($1.identifier)! })
    }
}

private extension DvrSeason {
    var sortedEpisodes: [DvrEpisode] {
        return episodes.sorted(by: { Int($0.identifier)! > Int($1.identifier)! })
    }
}
