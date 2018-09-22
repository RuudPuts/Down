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

class DvrShowDetailViewController: UIViewController & Routing & DvrApplicationInteracting {
    var application: DvrApplication!
    var interactorFactory: DvrInteractorProducing!
    var router: Router?

    @IBOutlet weak var headerView: DvrShowHeaderView?
    @IBOutlet weak var tableView: UITableView?

    private var headerViewModel: DvrShowHeaderViewModel?
    private var tableViewModel: DvrShowDetailsTableViewModel?

    private let disposeBag = DisposeBag()

    var show: DvrShow? {
        didSet {
            configureHeaderView()

            checkShowBanner()
            checkShowPoster()
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
        headerViewModel = DvrShowHeaderViewModel(show: show!)
        headerView?.model = headerViewModel
    }

    func configureTableView() {
        tableViewModel = DvrShowDetailsTableViewModel(show: show!)
        tableView?.dataSource = tableViewModel
        tableView?.delegate = tableViewModel
    }

    func checkShowBanner() {
        guard let show = show, let application = application,
            AssetStorage.banner(for: show) == nil else {
            return
        }

        interactorFactory
            .makeShowBannerInteractor(for: application, show: show)
            .observe()
            .subscribe(onNext: { _ in
                self.configureHeaderView()
            })
            .disposed(by: disposeBag)    }

    func checkShowPoster() {
        guard let show = show, let application = application,
            AssetStorage.poster(for: show) == nil else {
            return
        }

        interactorFactory
            .makeShowPosterInteractor(for: application, show: show)
            .observe()
            .subscribe(onNext: { _ in
                self.configureHeaderView()
            })
            .disposed(by: disposeBag)
    }
}
