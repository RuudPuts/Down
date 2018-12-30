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
import RxResult

class DvrShowDetailViewController: UIViewController, Depending {
    typealias Dependencies = DvrShowDetailsViewModel.Dependencies
        & DvrRequestBuilderDependency
        & RouterDependency
        & ErrorHandlerDependency
    let dependencies: Dependencies

    @IBOutlet weak var headerView: DvrShowHeaderView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var deleteButton: UIButton!

    private let viewModel: DvrShowDetailsViewModel
    private let tableViewModel: DvrShowDetailsTableViewModel

    private var disposeBag: DisposeBag!

    init(dependencies: Dependencies, viewModel: DvrShowDetailsViewModel) {
        self.dependencies = dependencies
        self.viewModel = viewModel

        self.tableViewModel = DvrShowDetailsTableViewModel(dependencies: dependencies)
        super.init(nibName: nil, bundle: nil)

        self.tableViewModel.context = self
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

        disposeBag = DisposeBag()
        bind(to: viewModel)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        disposeBag = nil
    }
    
    func applyStyling() {
        view.style(as: .backgroundView)
        navigationController?.navigationBar.style(as: .transparentNavigationBar)
        tableView?.style(as: .defaultTableView)
        deleteButton.style(as: .deleteButton)
    }
    func configureTableView() {
        tableViewModel.prepare( tableView!)

        tableView.dataSource = tableViewModel
        tableView.delegate = tableViewModel
    }
}

extension DvrShowDetailViewController: ReactiveBinding {
    typealias Bindable = DvrShowDetailsViewModel

    func bind(input: DvrShowDetailsViewModel.Input) {
        deleteButton.rx.tap
            .bind(to: input.deleteShow)
            .disposed(by: disposeBag)
    }

    func bind(output: DvrShowDetailsViewModel.Output) {
        output.refinedShow
            .do(onNext: { show in
                self.headerView?.configure(with: show)
            })
            .drive()
            .disposed(by: disposeBag)

        output.refinedShow
            .drive(tableViewModel.rx.refinedShow)
            .disposed(by: disposeBag)

        output.refinedShow
            .do(onNext: { _ in
                self.tableView.reloadData()
            })
            .drive()
            .disposed(by: disposeBag)

        output.showDeleted
            .do(
                onSuccess: {
                    self.dependencies.router.close(viewController: self)
                },
                onFailure: {
                    self.dependencies.errorHandler.handle(error: $0,
                                                          action: .dvr_deleteShow,
                                                          source: self)
                }
            )
            .subscribe()
            .disposed(by: disposeBag)

        tableView.rx.itemSelected
            .asObservable()
            .subscribe(onNext: { _ in
                self.tableView.animateCellResize()
            })
            .disposed(by: disposeBag)
    }
}
