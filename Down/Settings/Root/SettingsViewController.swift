//
//  SettingsViewController.swift
//  Down
//
//  Created by Ruud Puts on 02/10/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import UIKit
import DownKit
import RxSwift
import RxCocoa
import RxSwiftExt

class SettingsViewController: UIViewController {
    typealias Dependencies = ApplicationPersistenceDependency & RouterDependency
    let dependencies: Dependencies!

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var welcomeMessageLabel: UILabel!

    private var viewModel: SettingsViewModel
    private var tableViewModel: SettingsTableViewModel

    private var disposeBag: DisposeBag!

    init(dependencies: Dependencies, viewModel: SettingsViewModel) {
        self.dependencies = dependencies
        self.viewModel = viewModel
        self.tableViewModel = SettingsTableViewModel(viewModel: viewModel)

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureTableView()
        applyStyling()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        disposeBag = DisposeBag()
        bind(to: viewModel)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        disposeBag = nil
    }

    func applyStyling() {
        view.style(as: .backgroundView)
        welcomeMessageLabel.style(as: .headerLabel)
        tableView.style(as: .defaultTableView)
        tableView.sectionHeaderHeight = 80
    }

    func configureTableView() {
        tableViewModel.prepare(tableView)

        tableView.dataSource = tableViewModel
        tableView.delegate = tableViewModel
    }
}

extension SettingsViewController: ReactiveBinding {
    typealias Bindable = SettingsViewModel

    func bind(input: SettingsViewModel.Input) {
        tableView.rx.itemSelected
            .asObservable()
            .bind(to: input.itemSelected)
            .disposed(by: disposeBag)
    }

    func bind(output: SettingsViewModel.Output) {
        output.title
            .drive(rx.title)
            .disposed(by: disposeBag)

        bindWelcomeMessage(output.welcomeMessage)
        bindTableSections(output.sectionData)
        bindNavigation(output.navigateToDetails)
    }

    private func bindWelcomeMessage(_ welcomeMessage: Driver<String>) {
        welcomeMessage
            .drive(welcomeMessageLabel.rx.text)
            .disposed(by: disposeBag)

        welcomeMessage
            .map { $0.isEmpty }
            .drive(welcomeMessageLabel.rx.isHidden)
            .disposed(by: disposeBag)
    }

    private func bindTableSections(_ sections: Driver<[SettingsSectionModel]>) {
        sections
            .drive(tableViewModel.rx.datasource)
            .disposed(by: disposeBag)
    }

    private func bindNavigation(_ navigateToDetails: Observable<ApiApplication>) {
        navigateToDetails
            .subscribe(onNext: {
                self.dependencies.router.settingsRouter.showSettings(for: $0)
            })
            .disposed(by: disposeBag)

        navigateToDetails
            .map { _ in self.tableView.indexPathForSelectedRow }
            .asObservable()
            .unwrap()
            .subscribe(onNext: { self.tableView.deselectRow(at: $0, animated: true) })
            .disposed(by: disposeBag)
    }
}
