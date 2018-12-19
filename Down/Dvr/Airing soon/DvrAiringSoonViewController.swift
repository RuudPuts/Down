//
//  DvrAiringSoonViewController.swift
//  Down
//
//  Created by Ruud Puts on 17/12/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import UIKit
import DownKit
import RxSwift
import RxCocoa

class DvrAiringSoonViewController: UIViewController & Depending {
    typealias Dependencies = RouterDependency & DvrApplicationDependency
    let dependencies: Dependencies

    @IBOutlet weak var tableView: UITableView!

    private let viewModel: DvrAiringSoonViewModel
    private let tableController: DvrAiringSoonTableController

    private var disposeBag: DisposeBag!

    init(dependencies: Dependencies, viewModel: DvrAiringSoonViewModel) {
        self.dependencies = dependencies
        self.viewModel = viewModel
        tableController = DvrAiringSoonTableController(application: dependencies.dvrApplication)

        super.init(nibName: nil, bundle: nil)
        title = viewModel.title
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        applyStyling()
        tableController.prepare(tableView)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        bind(to: viewModel)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        disposeBag = nil
    }

    private func applyStyling() {
        view.style(as: .backgroundView)
        tableView.style(as: .defaultTableView)
    }
}

extension DvrAiringSoonViewController: ReactiveBinding {
    func makeInput() -> DvrAiringSoonViewModel.Input {
        return DvrAiringSoonViewModel.Input()
    }

    func bind(to viewModel: DvrAiringSoonViewModel) {
        disposeBag = DisposeBag()

        let output = viewModel.transform(input: makeInput())
        output.sections
            .bind(to: tableView.rx.items(dataSource: tableController.dataSource))
            .disposed(by: disposeBag)
    }
}
