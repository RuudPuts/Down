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

class DvrShowDetailViewController: UIViewController & DvrApplicationInteracting {
    var dvrApplication: DvrApplication!
    var dvrInteractorFactory: DvrInteractorProducing!
    var dvrRequestBuilder: DvrRequestBuilding!

    @IBOutlet weak var headerView: DvrShowHeaderView?
    @IBOutlet weak var tableView: UITableView?

    private var tableViewModel: DvrShowDetailsTableViewModel?
    private let disposeBag = DisposeBag()

    var show: DvrShow? {
        didSet {
            configureTableView()
            configureHeaderView()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        applyStyling()
        configureHeaderView()
        configureTableView()
        tableViewModel?.prepare(tableView: tableView!)
    }
    
    func applyStyling() {
        view.style(as: .backgroundView)
        navigationController?.navigationBar.style(as: .transparentNavigationBar)

        tableView?.tableFooterView = UIView()
        tableView?.separatorColor = Stylesheet.Colors.Backgrounds.lightGray
    }

    func configureHeaderView() {
        guard let show = show else {
            return
        }

        headerView?.viewModel = DvrShowHeaderViewModel(show: show,
                                                       bannerUrl: dvrRequestBuilder.url(for: .fetchBanner(show)),
                                                       posterUrl: dvrRequestBuilder.url(for: .fetchPoster(show)))
    }

    func configureTableView() {
        guard let show = show else {
            return
        }

        tableViewModel = DvrShowDetailsTableViewModel(show: show, application: dvrApplication)
        tableView?.dataSource = tableViewModel
        tableView?.delegate = tableViewModel
    }
}
