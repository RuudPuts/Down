//
//  DownloadStatusViewController.swift
//  Down
//
//  Created by Ruud Puts on 27/05/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import UIKit
import XLActionController
import DownKit

import RxSwift
import RxCocoa
import RxResult

class DownloadStatusViewController: UIViewController & Depending {
    typealias Dependencies = DownloadStatusTableController.Dependencies
        & RouterDependency
        & DownloadApplicationDependency
        & ErrorHandlerDependency
    let dependencies: Dependencies

    @IBOutlet weak var activityView: ActivityView!
    @IBOutlet weak var headerView: ApplicationHeaderView!
    @IBOutlet weak var statusView: DownloadQueueStatusView!
    @IBOutlet weak var tableView: UITableView!

    private let viewModel: DownloadStatusViewModel
    private let tableController: DownloadStatusTableController

    let queuePaused = BehaviorSubject(value: false)
    let purgeHistory = BehaviorSubject(value: Void())

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
        configureQueueStatusView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        bind(to: viewModel)

        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if let navigationController = navigationController,
            navigationController.viewControllers.count > 1 {
            navigationController.setNavigationBarHidden(false, animated: animated)
        }
        else {
            disposeBag = nil
        }
    }

    private func applyStyling() {
        let applicationType = dependencies.downloadApplication.downType

        view.style(as: .backgroundView)
        tableView.style(as: .defaultTableView)
        headerView.style(as: .headerView(for: applicationType))
        activityView.configure(with: viewModel.activityViewText, application: applicationType)
    }
    
    private func configureTableView() {
        tableView.delegate = tableController
        
        tableController.prepare(tableView)
    }

    private func configureQueueStatusView() {
        statusView.configure(with: dependencies.downloadApplication)
        statusView.heightConstraint?.constant = 0
    }

    private func showContextMenu(queuePaused: Bool) {
        let actionController = DownActionController(applicationType: dependencies.downloadApplication.downType)

        if queuePaused {
            actionController.addAction(title: "Resume downloads", image: R.image.icon_resume(), handler: { _ in
                self.queuePaused.onNext(false)
            })
        }
        else {
            actionController.addAction(title: "Pause downloads", image: R.image.icon_pause(), handler: { _ in
                self.queuePaused.onNext(true)
            })
        }

        actionController.addAction(title: "Purge history", image: R.image.icon_shred(), style: .destructive, handler: { _ in
            self.purgeHistory.onNext(Void())
        })

        actionController.addSection(Section())
        actionController.addAction(title: "Cancel", style: .cancel)

        present(actionController, animated: true, completion: nil)
    }
}

extension DownloadStatusViewController: ReactiveBinding {
    func makeInput() -> DownloadStatusViewModel.Input {
        let queuePaused = self.queuePaused.skip(1)

        let pauseQueue = queuePaused
            .filter { $0 }
            .asVoid()

        let resumeQueue = queuePaused
            .filter { !$0 }
            .asVoid()

        return DownloadStatusViewModel.Input(
            itemSelected: tableView.rx.itemSelected,
            pauseQueue: pauseQueue,
            resumeQueue: resumeQueue,
            purgeHistory: purgeHistory.skip(1)
        )
    }

    func bind(to viewModel: DownloadStatusViewModel) {
        disposeBag = DisposeBag()

        let output = viewModel.transform(input: makeInput())

        bindQueueStatus(output.queue)
        bindTableView(output.sectionsData)
        bindActions(output)

        output.itemSelected
            .subscribe(onNext: {
                self.dependencies.router.downloadRouter.showDetail(of: $0)
            })
            .disposed(by: disposeBag)

        headerView.contextButton.rx.tap
            .asObservable()
            .withLatestFrom(output.queue)
            .subscribe(onNext: { queue in
                self.showContextMenu(queuePaused: queue.isPaused)
            })
            .disposed(by: disposeBag)
    }

    private func bindQueueStatus(_ queue: Driver<DownloadQueue>) {
        queue
            .map { !$0.isPaused && $0.speedMb == 0 }
            .map { $0 ? 0.0 : 50.0 }
            .drive(rx.queueStatusViewHeight)
            .disposed(by: disposeBag)

        queue
            .drive(statusView.rx.queue)
            .disposed(by: disposeBag)
    }

    private func bindTableView(_ sectionsData: Driver<[TableSectionData<DownloadItem>]>) {
        sectionsData
            .do(onNext: { self.tableController.dataSource = $0 })
            .drive()
            .disposed(by: disposeBag)

        let dataLoaded = sectionsData
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
    }

    func bindActions(_ output: DownloadStatusViewModel.Output) {
        let actions = [
            (observable: output.queuePaused, action: ErrorSourceAction.download_pauseQueue),
            (observable: output.queueResumed, action: ErrorSourceAction.download_resumeQueue),
            (observable: output.historyPurged, action: ErrorSourceAction.download_purgeHistory)
        ]

        actions.forEach { data in
            data.observable
                .subscribeResult(onFailure: {
                    self.dependencies.errorHandler.handle(error: $0, action: data.action, source: self)
                })
                .disposed(by: disposeBag)
        }
    }
}

extension Reactive where Base: DownloadStatusViewController {
    var queueStatusViewHeight: Binder<Double> {
        return Binder(base) { statusViewController, queueHeight in
            let newHeight = CGFloat(queueHeight)

            guard let heightConstraint = statusViewController.statusView.heightConstraint,
                heightConstraint.constant != newHeight else {
                return
            }

            heightConstraint.constant = newHeight
            UIView.animate(withDuration: 0.3, animations: {
                statusViewController.view.layoutIfNeeded()
            })
        }
    }
}
