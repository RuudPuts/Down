//
//  DownloadItemDetailViewController.swift
//  Down
//
//  Created by Ruud Puts on 06/10/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import UIKit
import DownKit
import CircleProgressView
import Kingfisher

import RxSwift
import RxCocoa


class DownloadItemDetailViewController: UIViewController & Depending {
    typealias Dependencies = RouterDependency
        & DownloadInteractorFactoryDependency
        & DvrApplicationDependency
        & ErrorHandlerDependency
    let dependencies: Dependencies

    @IBOutlet weak var headerImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var progressView: CircleProgressView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var retryButton: UIButton!

    private let viewModel: DownloadItemDetailViewModel
    private let tableViewController: DownloadItemDetailTableViewController

    private var disposeBag: DisposeBag!

    init(dependencies: Dependencies, viewModel: DownloadItemDetailViewModel) {
        self.dependencies = dependencies
        self.viewModel = viewModel
        tableViewController = DownloadItemDetailTableViewController()

        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Details"

        configureContextButton()
        configureTableView()
        applyStyling()
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

    private func configureContextButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem.contextButton(target: self, action: #selector(showContextMenu))
    }

    private func configureTableView() {
        tableViewController.prepare(tableView)
    }

    private func applyStyling() {
        let applicationType = dependencies.downloadApplication.downType

        view.style(as: .backgroundView)
        navigationItem.rightBarButtonItem?.style(as: .barButtonItem(applicationType))
        tableView.style(as: .defaultTableView)
        titleLabel.style(as: .titleLabel)
        subtitleLabel.style(as: .titleLabel)
        statusLabel.style(as: .detailLabel)
        progressView.style(as: .progressView(for: applicationType))
        retryButton.style(as: .applicationButton(applicationType))
    }
}

@objc extension DownloadItemDetailViewController {
    func showContextMenu() {
        let actionController = DownActionController(applicationType: dependencies.downloadApplication.downType)

        actionController.addAction(title: "Delete", style: .destructive, handler: { _ in
            self.viewModel.input.deleteItem.onNext(Void())
        })

        actionController.addCancelSection()

        present(actionController, animated: true, completion: nil)
    }
}

extension DownloadItemDetailViewController: ReactiveBinding {
    typealias Bindable = DownloadItemDetailViewModel

    func bind(output: DownloadItemDetailViewModel.Output) {
        bindHeaderView(output.refinedItem)
        bindTableView(output.refinedItem)
        bindItemDeleted(output.itemDeleted)
    }

    private func bindHeaderView(_ refinedItem: Driver<DownloadItemDetailViewModel.RefinedItem>) {
        refinedItem.map { $0.title }
            .drive(titleLabel.rx.text)
            .disposed(by: disposeBag)

        refinedItem.map { $0.subtitle }
            .drive(subtitleLabel.rx.text)
            .disposed(by: disposeBag)

        refinedItem.map { $0.statusText }
            .drive(statusLabel.rx.text)
            .disposed(by: disposeBag)

        refinedItem.map { $0.statusStyle }
            .do(onNext: { self.statusLabel.style(as: $0) })
            .drive()
            .disposed(by: disposeBag)

        refinedItem.map { !$0.hasProgress }
            .drive(progressView.rx.isHidden)
            .disposed(by: disposeBag)

        refinedItem.map { $0.progress }
            .drive(progressView.rx.progress)
            .disposed(by: disposeBag)

        refinedItem.map { $0.headerImageUrl == nil }
            .drive(headerImageView.rx.isHidden)
            .disposed(by: disposeBag)

        refinedItem.map { $0.headerImageUrl }
            .do(onNext: { self.headerImageView.kf.setImage(with: $0) })
            .drive()
            .disposed(by: disposeBag)

        refinedItem.map { !$0.canRetry }
            .drive(retryButton.rx.isHidden)
            .disposed(by: disposeBag)
    }

    private func bindTableView(_ refinedItem: Driver<DownloadItemDetailViewModel.RefinedItem>) {
        refinedItem
            .map { $0.detailSections }
            .drive(tableViewController.rx.dataModel)
            .disposed(by: disposeBag)

        refinedItem
            .do(onNext: { _ in self.tableView.reloadData() })
            .drive()
            .disposed(by: disposeBag)
    }

    private func bindItemDeleted(_ itemDeleted: Observable<Swift.Result<Void, DownError>>) {
        itemDeleted
            .do(
                onSuccess: { _ in
                    self.dependencies.router.close(viewController: self)
                },
                onFailure: { error in
                    self.dependencies.errorHandler.handle(error: error,
                                                          action: .download_deleteItem,
                                                          source: self)
                }
            )
            .subscribe()
            .disposed(by: disposeBag)
    }
}
