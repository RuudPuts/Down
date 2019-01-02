//
//  DvrRecentlyAiredViewController.swift
//  Down
//
//  Created by Ruud Puts on 17/12/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import UIKit
import DownKit
import RxSwift
import RxCocoa

class DvrRecentlyAiredViewController: UIViewController & Depending {
    typealias Dependencies = RouterDependency & DvrApplicationDependency
    let dependencies: Dependencies

    @IBOutlet weak var tableView: UITableView!

    private let viewModel: DvrRecentlyAiredViewModel

    private var disposeBag: DisposeBag!

    init(dependencies: Dependencies, viewModel: DvrRecentlyAiredViewModel) {
        self.dependencies = dependencies
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
        title = viewModel.title
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        prepareTableView()
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

    private func prepareTableView() {
        tableView.registerCell(nibName: DvrRecentlyAiredCell.reuseIdentifier)
        tableView.delegate = self
    }

    private func applyStyling() {
        view.style(as: .backgroundView)
        tableView.style(as: .defaultTableView)
    }
}

extension DvrRecentlyAiredViewController: ReactiveBinding {
    typealias Bindable = DvrRecentlyAiredViewModel

    func bind(input: DvrRecentlyAiredViewModel.Input) {
        tableView.rx.itemSelected.do(onNext: {
                self.tableView.deselectRow(at: $0, animated: true)
            })
            .bind(to: input.itemSelected)
            .disposed(by: disposeBag)
    }

    func bind(output: DvrRecentlyAiredViewModel.Output) {
        output.data
            .bind(to: tableView.rx.items(cellIdentifier: DvrRecentlyAiredCell.reuseIdentifier,
                                         cellType: DvrRecentlyAiredCell.self)) { _, item, cell in
                                            cell.configure(with: item)
            }
            .disposed(by: disposeBag)

        output.episodeSelected
            .subscribe(onNext: {
                self.dependencies.router.dvrRouter.showDetail(of: $0.show, selectedEpisode: $0)
            })
            .disposed(by: disposeBag)
    }
}

extension DvrRecentlyAiredViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.style(as: .selectableTableViewCell(application: dependencies.dvrApplication.downType))
    }
}
