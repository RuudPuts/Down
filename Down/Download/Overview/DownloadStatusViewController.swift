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

    @IBOutlet weak var activityView: ActivityView!
    @IBOutlet weak var headerView: ApplicationHeaderView!
    @IBOutlet weak var statusView: DownloadQueueStatusView!
    @IBOutlet weak var tableView: UITableView!

    private let viewModel: DownloadStatusViewModel
    private let tableController: DownloadStatusTableController

    private var disposeBag: DisposeBag!

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
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        bind(to: viewModel)

        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        disposeBag = nil

        if let navigationController = navigationController,
            navigationController.viewControllers.count > 1 {
            navigationController.setNavigationBarHidden(false, animated: animated)
        }
    }

    func applyStyling() {
        view.style(as: .backgroundView)
        tableView.style(as: .defaultTableView)
        headerView.style(as: .headerView(for: dependencies.downloadApplication.downType))
        activityView.configure(with: viewModel.activityViewText,
                               application: dependencies.downloadApplication.downType)
    }
    
    func configureTableView() {
        tableView.delegate = tableController
        
        tableController.prepare(tableView)
    }
}

extension DownloadStatusViewController: ReactiveBinding {
    func makeInput() -> DownloadStatusViewModel.Input {
        return DownloadStatusViewModel.Input(itemSelected: tableView.rx.itemSelected)
    }

    func bind(to viewModel: DownloadStatusViewModel) {
        disposeBag = DisposeBag()

        let output = viewModel.transform(input: makeInput())

        output.queue
            .drive(statusView.rx.queue)
            .disposed(by: disposeBag)

        output.sectionsData
            .drive(tableView.rx.items(dataSource: tableController.dataSource))
            .disposed(by: disposeBag)

        let dataLoaded = output.sectionsData
            .map { _ in true }
            .startWith(false)

        dataLoaded
            .drive(activityView.rx.isHidden)
            .disposed(by: disposeBag)

        [tableView.rx.isHidden, statusView.rx.isHidden].forEach {
            dataLoaded
                .map { !$0 }
                .drive($0)
                .disposed(by: disposeBag)
        }

        output.itemSelected
            .subscribe(onNext: {
                self.dependencies.router.downloadRouter.showDetail(of: $0)
            })
            .disposed(by: disposeBag)
    }
}
