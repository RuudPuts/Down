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

class DownloadItemDetailViewController: UIViewController & Depending & DownloadApplicationInteracting & DvrApplicationInteracting {
    typealias Dependencies = RouterDependency
    let dependencies: Dependencies

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

    init(dependencies: Dependencies) {
        self.dependencies = dependencies

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

    func configureTableView() {
        tableView.tableFooterView = UIView()
        
        tableViewController?.prepare(tableView: tableView)
        tableView.dataSource = tableViewController
    }

    func applyStyling() {
        view.style(as: .backgroundView)
        tableView.style(as: .defaultTableView)
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

        headerImageView.kf.setImage(with: viewModel.headerImageUrl)

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

                self.dependencies.router.close(viewController: self)
            })
            .disposed(by: footerDisposeBag)
    }
}
