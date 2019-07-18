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
    typealias Dependencies = DvrShowDetailsViewModel.Dependencies
        & DvrRequestBuilderDependency
        & RouterDependency
        & ErrorHandlerDependency
    let dependencies: Dependencies

    @IBOutlet weak var headerView: DvrShowHeaderView!
    @IBOutlet weak var tableView: UITableView!

    private let viewModel: DvrShowDetailsViewModel
    private let tableViewModel: DvrShowDetailsTableViewModel

    private var initialSelectedEpisode: DvrEpisode?
    private var disposeBag: DisposeBag!

    init(dependencies: Dependencies, viewModel: DvrShowDetailsViewModel, selectedEpisode: DvrEpisode? = nil) {
        self.dependencies = dependencies
        self.viewModel = viewModel
        self.initialSelectedEpisode = selectedEpisode

        self.tableViewModel = DvrShowDetailsTableViewModel(dependencies: dependencies)
        super.init(nibName: nil, bundle: nil)

        self.tableViewModel.context = self
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureContextButton()
        configureTableView()
        applyStyling()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        disposeBag = DisposeBag()
        bind(to: viewModel)

        if let episode = initialSelectedEpisode {
            tableViewModel.selectEpisode(episode)
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        disposeBag = nil
    }

    private func configureContextButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem.contextButton(target: self, action: #selector(showContextMenu))
    }
    
    private func applyStyling() {
        let applicationType = dependencies.dvrApplication.downType

        view.style(as: .backgroundView)
        tableView.style(as: .defaultTableView)
        navigationItem.rightBarButtonItem?.style(as: .barButtonItem(applicationType))
    }

    private func configureTableView() {
        tableViewModel.prepare(tableView)

        tableView.dataSource = tableViewModel
        tableView.delegate = tableViewModel
    }
}

@objc extension DvrShowDetailViewController {
    func showContextMenu() {
        let actionController = DownActionController(applicationType: dependencies.dvrApplication.downType)

        actionController.addAction(title: "Delete", style: .destructive, handler: { _ in
            self.viewModel.input.deleteShow.onNext(Void())
        })

        actionController.addCancelSection()

        present(actionController, animated: true, completion: nil)
    }
}

extension DvrShowDetailViewController: ReactiveBinding {
    typealias Bindable = DvrShowDetailsViewModel

    func bind(output: DvrShowDetailsViewModel.Output) {
        output.refinedShow
            .drive(headerView.rx.refinedShow)
            .disposed(by: disposeBag)

        output.refinedShow
            .drive(tableViewModel.rx.refinedShow)
            .disposed(by: disposeBag)

        output.showDeleted
            .do(
                onSuccess: {
                    self.disposeBag = nil
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
