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
    typealias Dependencies = DvrShowDetailsViewModel.Dependencies & DvrRequestBuilderDependency & RouterDependency
    let dependencies: Dependencies

    @IBOutlet weak var headerView: DvrShowHeaderView?
    @IBOutlet weak var tableView: UITableView?
    @IBOutlet weak var deleteButton: UIButton!

    private let viewModel: DvrShowDetailsViewModel
    private let tableViewModel: DvrShowDetailsTableViewModel

    private let viewModelDisposeBag = DisposeBag()
    private var footerDisposeBag = DisposeBag()

    init(dependencies: Dependencies, viewModel: DvrShowDetailsViewModel) {
        self.dependencies = dependencies
        self.viewModel = viewModel

        self.tableViewModel = DvrShowDetailsTableViewModel(dependencies: dependencies,
                                                           viewModel: viewModel)
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
        bindFooterButtons()
    }
    
    func applyStyling() {
        view.style(as: .backgroundView)
        navigationController?.navigationBar.style(as: .transparentNavigationBar)

        tableView?.tableFooterView = UIView()
        tableView?.separatorColor = Stylesheet.Colors.Backgrounds.lightGray

        deleteButton.style(as: .deleteButton)
    }

    func configureHeaderView() {
        headerView?.viewModel = DvrShowHeaderViewModel(show: viewModel.show,
                                                       bannerUrl: viewModel.bannerUrl,
                                                       posterUrl: viewModel.posterUrl)
    }

    func configureTableView() {
        tableView?.dataSource = tableViewModel
        tableView?.delegate = tableViewModel
    }

    private func bindFooterButtons() {
        deleteButton.rx.tap
            .asObservable()
            .flatMap { _ in
                self.viewModel.deleteShow()
            }
            .subscribe(onNext: {
                guard $0 else {
                    return
                }

                self.dependencies.router.close(viewController: self)
            })
            .disposed(by: footerDisposeBag)
    }
}
