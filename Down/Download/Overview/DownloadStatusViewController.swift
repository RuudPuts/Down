//
//  DownloadStatusViewController.swift
//  Down
//
//  Created by Ruud Puts on 27/05/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import UIKit
import DownKit
import RxSwift
import RxCocoa

class DownloadStatusViewController: UIViewController & Depending {
    typealias Dependencies = DownloadStatusTableController.Dependencies & RouterDependency & DownloadApplicationDependency
    let dependencies: Dependencies

    @IBOutlet weak var headerView: ApplicationHeaderView!
    @IBOutlet weak var statusView: DownloadQueueStatusView!
    @IBOutlet weak var tableView: UITableView!

    private let disposeBag = DisposeBag()
    private let viewModel: DownloadStatusViewModel
    private let tableController: DownloadStatusTableController

    init(dependencies: Dependencies, viewModel: DownloadStatusViewModel) {
        self.dependencies = dependencies
        self.viewModel = viewModel
        tableController = DownloadStatusTableController(dependencies: dependencies)

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        applyStyling()
        configureTableView()
        bind(to: viewModel)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if let navigationController = navigationController,
            navigationController.viewControllers.count > 1 {
            navigationController.setNavigationBarHidden(false, animated: animated)
        }
    }

    func applyStyling() {
        view.style(as: .backgroundView)
//        tableView.style(as: .cardTableView)
        tableView.style(as: .defaultTableView)
        headerView.style(as: .headerView(for: dependencies.downloadApplication.downType))
    }
    
    func configureTableView() {
        tableView.dataSource = tableController
        tableView.delegate = tableController
        
        tableController.prepare(tableView: tableView)
    }
}

extension DownloadStatusViewController: ReactiveBinding {
    typealias Bindable = DownloadStatusViewModel

    func bind(to viewModel: DownloadStatusViewModel) {
        let output = viewModel.transform(input: makeInput())

        output.queue
            .drive(statusView.rx.queue)
            .disposed(by: disposeBag)

        output.sectionsData
            .drive(tableController.rx.datasource)
            .disposed(by: disposeBag)

        output.navigateToDetails
            .subscribe(onNext: { self.dependencies.router.downloadRouter.showDetail(of: $0) })
            .disposed(by: disposeBag)
    }

    func makeInput() -> DownloadStatusViewModel.Input {
        return DownloadStatusViewModel.Input(itemSelected: tableView.rx.itemSelected)
    }
}
