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

    private let disposeBag = DisposeBag()

    init(dependencies: Dependencies, viewModel: DvrShowDetailsViewModel) {
        self.dependencies = dependencies
        self.viewModel = viewModel

        self.tableViewModel = DvrShowDetailsTableViewModel(dependencies: dependencies)
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
    
    func applyStyling() {
        view.style(as: .backgroundView)
        navigationController?.navigationBar.style(as: .transparentNavigationBar)

        tableView?.tableFooterView = UIView()
        tableView?.separatorColor = Stylesheet.Colors.Backgrounds.lightGray

        deleteButton.style(as: .deleteButton)
    }
    func configureTableView() {
        tableViewModel.prepare(tableView: tableView!)

        tableView.dataSource = tableViewModel
        tableView.delegate = tableViewModel
    }
}

extension DvrShowDetailViewController: ReactiveBinding {
    typealias Bindable = DvrShowDetailsViewModel

    func bind(to viewModel: DvrShowDetailsViewModel) {
        let output = viewModel.transform(input: makeInput())

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
                    //! Shouldn't this return void by now?
                    guard $0 else { return }

                    self.dependencies.router.close(viewController: self)
                },
                onFailure: {
                    self.dependencies.errorHandler.handle(error: $0,
                                                          type: .dvr_deleteShow,
                                                          source: self)
                }
            )
            .subscribe()
            .disposed(by: disposeBag)
    }

    func makeInput() -> DvrShowDetailsViewModel.Input {
        let deleteButtonTapped = deleteButton.rx.tap

        return DvrShowDetailsViewModel.Input(deleteShow: deleteButtonTapped)
    }
}
