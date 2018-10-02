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

    override func viewDidLoad() {
        super.viewDidLoad()

        applyStyling()
        applyViewModel()
    }

    func applyStyling() {
        view.style(as: .backgroundView)

        navigationController?.navigationBar.style(as: .defaultNavigationBar)
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: Stylesheet.Colors.red]

//        tableView?.tableFooterView = UIView()
//        tableView?.separatorColor = Stylesheet.Colors.Backgrounds.lightGray
    }

    func applyViewModel() {
        title = viewModel.title
        navigationController?.tabBarItem.title = nil
    }

//    func configureTableView() {
//        guard let show = show else {
//            return
//        }
//
//        tableViewModel = DvrShowDetailsTableViewModel(show: show, application: application)
//        tableView?.dataSource = tableViewModel
//        tableView?.delegate = tableViewModel
//    }
}
