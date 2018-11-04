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
    typealias Dependencies = RouterDependency & DownloadInteractorFactoryDependency & DvrApplicationDependency
    let dependencies: Dependencies

    private let viewModel: DownloadItemDetailViewModel
    private let tableViewController: DownloadItemDetailTableViewController

    @IBOutlet weak var headerImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var progressView: CircleProgressView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var retryButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!

    private var viewModelDisposeBag = DisposeBag()
    private var footerDisposeBag = DisposeBag()

    init(dependencies: Dependencies, viewModel: DownloadItemDetailViewModel) {
        self.dependencies = dependencies
        self.viewModel = viewModel
        tableViewController = DownloadItemDetailTableViewController(dataModel: viewModel.detailRows)

        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Details"

        configureTableView()
        applyViewModel()
        applyStyling()
    }

    private func configureTableView() {
        tableView.tableFooterView = UIView()
        
        tableViewController.prepare(tableView: tableView)
        tableView.dataSource = tableViewController
    }

    private func applyStyling() {
        view.style(as: .backgroundView)
        tableView.style(as: .defaultTableView)
        titleLabel.style(as: .boldTitleLabel)
        subtitleLabel.style(as: .titleLabel)
        statusLabel.style(as: .detailLabel)
        progressView.style(as: .progressView(for: dependencies.downloadApplication.downType))
        retryButton.style(as: .applicationButton(dependencies.dvrApplication.downType))
        deleteButton.style(as: .deleteButton)
    }

    private func applyViewModel() {
        viewModelDisposeBag = DisposeBag()

        titleLabel.text = viewModel.title
        subtitleLabel.text = viewModel.subtitle
        statusLabel.text = viewModel.statusText
        statusLabel.style(as: viewModel.statusStyle)
        progressView.isHidden = !viewModel.itemHasProgress
        retryButton.isHidden = !viewModel.itemCanRetry

        headerImageView.kf.setImage(with: viewModel.headerImageUrl)

        bindFooterButtons()
        tableView.reloadData()
    }

    private func bindFooterButtons() {
        deleteButton.rx.tap
            .asObservable()
            .flatMap { _ in
                self.viewModel.deleteDownloadItem(dependencies: self.dependencies)
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
