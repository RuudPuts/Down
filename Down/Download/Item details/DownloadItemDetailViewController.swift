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

import RxSwift
import RxCocoa

class DownloadItemDetailViewController: UIViewController & Routing & DownloadApplicationInteracting & DvrApplicationInteracting {
    var downloadApplication: DownloadApplication!
    var downloadInteractorFactory: DownloadInteractorProducing!

    var dvrApplication: DvrApplication!
    var dvrInteractorFactory: DvrInteractorProducing!

    var viewModel: DownloadItemDetailViewModel? {
        didSet {
            tableViewController = DownloadItemDetailTableViewController(dataModel: viewModel?.detailRows ?? [])
        }
    }
    var tableViewController: DownloadItemDetailTableViewController?
    var router: Router?

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

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Details"

        configureTableView()
        applyViewModel()
        applyStyling()
    }

    func configureTableView() {
        tableView.tableFooterView = UIView()
        
        tableViewController?.prepare(tableView: tableView)
        tableView.dataSource = tableViewController
    }

    func applyStyling() {
        view.style(as: .backgroundView)
        titleLabel.style(as: .boldTitleLabel)
        subtitleLabel.style(as: .titleLabel)
        statusLabel.style(as: .detailLabel)
        progressView.style(as: .progressView(for: downloadApplication.downType))
        retryButton.style(as: .applicationButton(dvrApplication.downType))
        deleteButton.style(as: .deleteButton)
    }

    func applyViewModel() {
        viewModelDisposeBag = DisposeBag()

        guard let viewModel = viewModel else {
            tableView.reloadData()
            return
        }

        titleLabel.text = viewModel.title
        subtitleLabel.text = viewModel.subtitle
        statusLabel.text = viewModel.statusText
        statusLabel.style(as: viewModel.statusStyle)
        progressView.isHidden = !viewModel.itemHasProgress
        retryButton.isHidden = !viewModel.itemCanRetry

        let headerImage = viewModel
            .fetchHeaderImage()

        headerImage
            .drive(headerImageView.rx.image)
            .disposed(by: viewModelDisposeBag)

        headerImage
            .map { $0 == nil }
            .startWith(true)
            .drive(headerImageView.rx.isHidden)
            .disposed(by: viewModelDisposeBag)

        bindFooterButtons()
        tableView.reloadData()
    }

    func bindFooterButtons() {
        guard let viewModel = viewModel else {
            return
        }

        deleteButton.rx.tap
            .asObservable()
            .flatMap { _ in
                viewModel.deleteDownloadItem()
            }
            .subscribe(onNext: {
                guard $0 else {
                    return
                }

                self.router?.close(viewController: self)
            })
            .disposed(by: footerDisposeBag)
    }
}
