//
//  SettingsViewController.swift
//  Down
//
//  Created by Ruud Puts on 02/10/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController & Routing {
    var router: Router?
    var viewModel: SettingsViewModel!
    var tableViewModel: SettingsTableViewModel?

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        applyStyling()
        applyViewModel()
        configureTableView()
    }

    func applyStyling() {
        view.style(as: .backgroundView)

        navigationController?.navigationBar.style(as: .defaultNavigationBar)
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: Stylesheet.Colors.red]

        tableView.style(as: .defaultTableView)
        tableView.sectionHeaderHeight = 80
        tableView.tableFooterView = UIView()
        tableView.separatorColor = Stylesheet.Colors.Backgrounds.lightGray
    }

    func applyViewModel() {
        title = viewModel.title
        navigationController?.tabBarItem.title = nil

        if viewModel.showWelcomeMessage {
            let headerLabel = UILabel()
            headerLabel.numberOfLines = 0
            headerLabel.text = viewModel.welcomeMessage
            headerLabel.style(as: .headerLabel)

            let size = headerLabel.sizeThatFits(CGSize(width: tableView.bounds.width, height: 200))
            headerLabel.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height + 30)

            tableView.tableHeaderView = headerLabel
        }
        else {
            tableView.tableHeaderView = nil
        }
    }

    func configureTableView() {
        tableViewModel = SettingsTableViewModel(viewModel: viewModel, router: router)
        tableViewModel?.prepare(tableView: tableView)

        tableView.dataSource = tableViewModel
        tableView.delegate = tableViewModel
    }
}
