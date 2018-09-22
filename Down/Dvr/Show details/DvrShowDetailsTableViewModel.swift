//
//  DvrShowDetailsTableViewModel.swift
//  Down
//
//  Created by Ruud Puts on 09/09/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import DownKit

class DvrShowDetailsTableViewModel: NSObject {
    var show: DvrShow

    init(show: DvrShow) {
        self.show = show
    }

    func prepare(tableView: UITableView) {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.registerHeaderFooter(nibName: TableHeaderView.identifier)
    }
}

extension DvrShowDetailsTableViewModel: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return show.seasons.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return show.seasons[section].episodes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        let episode = show.seasons[indexPath.section].episodes[indexPath.row]
        cell.textLabel?.text = "\(indexPath.row + 1). \(episode.name)"

        return cell
    }
}

extension DvrShowDetailsTableViewModel: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: TableHeaderView.identifier)
        guard let headerView = view as? TableHeaderView else {
            return nil
        }

        let season = show.seasons[section]
        headerView.viewModel = TableHeaderViewModel(title: "Season \(season.identifier)", icon: nil)

        return view
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.style(as: .defaultCell)
    }
}
