//
//  DvrShowDetailViewController.swift
//  Down
//
//  Created by Ruud Puts on 03/06/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import DownKit
import RxSwift
import UIKit

class DvrShowDetailViewController: UIViewController, Depending {
    typealias Dependencies = DvrShowDetailsTableViewModel.Dependencies & DvrRequestBuilderDependency
    let dependencies: Dependencies

    @IBOutlet weak var headerView: DvrShowHeaderView?
    @IBOutlet weak var tableView: UITableView?

    private let show: DvrShow
    private let tableViewModel: DvrShowDetailsTableViewModel

    private let disposeBag = DisposeBag()

    init(dependencies: Dependencies, show: DvrShow) {
        self.dependencies = dependencies
        self.show = show

        self.tableViewModel = DvrShowDetailsTableViewModel(dependencies: dependencies,
                                                           show: show)

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        applyStyling()
        configureHeaderView()
        configureTableView()
        tableViewModel.prepare(tableView: tableView!)
    }
    
    func applyStyling() {
        view.style(as: .backgroundView)
        navigationController?.navigationBar.style(as: .transparentNavigationBar)

        tableView?.tableFooterView = UIView()
        tableView?.separatorColor = Stylesheet.Colors.Backgrounds.lightGray
    }

    func configureHeaderView() {
        let bannerUrl = dependencies.dvrRequestBuilder.url(for: .fetchBanner(show))
        let posterUrl = dependencies.dvrRequestBuilder.url(for: .fetchPoster(show))

        headerView?.viewModel = DvrShowHeaderViewModel(show: show,
                                                       bannerUrl: bannerUrl,
                                                       posterUrl: posterUrl)
    }

    func configureTableView() {
        tableView?.dataSource = tableViewModel
        tableView?.delegate = tableViewModel
    }
}
