//
//  DvrAiringSoonTableController.swift
//  Down
//
//  Created by Ruud Puts on 18/12/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import UIKit

class DvrAiringSoonTableController: SectionedTableController<DvrAiringSoonViewModel.RefinedEpisode> {
    override func prepare(_ tableView: UITableView) {
        super.prepare(tableView)

        tableView.registerCell(nibName: DvrAiringSoonCell.reuseIdentifier)
    }

    override func cell(forItem item: DvrAiringSoonViewModel.RefinedEpisode, atIndexPath indexPath: IndexPath, inTableView tableView: UITableView) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DvrAiringSoonCell.reuseIdentifier, for: indexPath)

        guard let itemCell = cell as? DvrAiringSoonCell else {
            return cell
        }

        itemCell.configure(with: item)

        return cell
    }
}
