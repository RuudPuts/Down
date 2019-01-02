//
//  PagingViewController.swift
//  Down
//
//  Created by Ruud Puts on 16/12/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import UIKit
import Parchment
import DownKit
import RxSwift
import RxCocoa

class PagingViewController: UIViewController {
    @IBOutlet weak var activityView: ActivityView!
    @IBOutlet weak var headerView: ApplicationHeaderView!
    @IBOutlet weak var containerView: UIView!

    let application: ApiApplication

    private let viewModel: PagingViewModel
    private let viewControllers: [UIViewController]
    private let pagingViewController: FixedPagingViewController
    private let disposeBag = DisposeBag()

    init(viewModel: PagingViewModel, viewControllers: [UIViewController], application: ApiApplication) {
        self.viewModel = viewModel
        self.viewControllers = viewControllers
        self.application = application

        pagingViewController = FixedPagingViewController(viewControllers: viewControllers)
        
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        applyStyling()
        showPagingController()
        configurePagingController()
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

    private func applyStyling() {
        view.style(as: .backgroundView)

        let applicationType = application.downType
        headerView.style(as: .headerView(for: applicationType))
        pagingViewController.style(as: .pagingViewController(for: applicationType))
        activityView.configure(with: viewModel.dataLoadDescription, application: applicationType)
    }

    private func showPagingController() {
        addChild(pagingViewController)
        containerView.addSubview(pagingViewController.view)
        pagingViewController.didMove(toParent: self)
        pagingViewController.view.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            pagingViewController.view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            pagingViewController.view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            pagingViewController.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            pagingViewController.view.topAnchor.constraint(equalTo: containerView.topAnchor)
        ])
    }

    private func configurePagingController() {
        pagingViewController.delegate = self
        pagingViewController.select(index: 1, animated: false)
    }

    func showContextMenu() { }
}

extension PagingViewController: PagingViewControllerDelegate {
    func pagingViewController<T>(_ pagingViewController: Parchment.PagingViewController<T>, pagingItemForIndex index: Int) -> PagingItem {
        return PagingIndexItem(index: index, title: viewControllers[index].title ?? "")
    }
}

extension PagingViewController {
    func makeInput() -> PagingViewModelInput {
        return PagingViewModelInput(loadData: Observable.just(Void()))
    }

    func bind(to viewModel: PagingViewModel) {
        let output = viewModel.transform(input: makeInput())

        output.loadingData
            .map { !$0 }
            .drive(activityView.rx.isHidden)
            .disposed(by: disposeBag)

        output.loadingData
            .drive(containerView.rx.isHidden)
            .disposed(by: disposeBag)

        output.data
            .drive()
            .disposed(by: disposeBag)

        output.loadingData
            .map { !$0 }
            .drive(headerView.contextButton.rx.isEnabled)
            .disposed(by: disposeBag)

        headerView.contextButton.rx.tap
            .asObservable()
            .subscribe(onNext: {
                self.showContextMenu()
            })
            .disposed(by: disposeBag)
    }
}
