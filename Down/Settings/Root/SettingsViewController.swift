//
//  SettingsViewController.swift
//  Down
//
//  Created by Ruud Puts on 02/10/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxSwiftExt

class SettingsViewController: UIViewController {
    typealias Dependencies = ApplicationPersistenceDependency & RouterDependency
    let dependencies: Dependencies!

    @IBOutlet private weak var tableView: UITableView!
    private lazy var welcomeMessageLabel: UILabel = {
        let headerLabel = UILabel()
        headerLabel.numberOfLines = 0
        headerLabel.style(as: .headerLabel)

        return headerLabel
    }()

    private var viewModel: SettingsViewModel
    private var tableViewModel: SettingsTableViewModel

    private let disposeBag = DisposeBag()

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
        
        bind(to: viewModel)
    }

    func applyStyling() {
        view.style(as: .backgroundView)

        navigationController?.tabBarItem.title = nil
        navigationController?.navigationBar.style(as: .defaultNavigationBar)
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: Stylesheet.Colors.red]

        tableView.style(as: .defaultTableView)
        tableView.sectionHeaderHeight = 80
        tableView.tableFooterView = UIView()
        tableView.separatorColor = Stylesheet.Colors.Backgrounds.lightGray
    }

    func configureTableView() {
        tableViewModel.prepare(tableView: tableView)

        tableView.dataSource = tableViewModel
        tableView.delegate = tableViewModel
    }
}

extension SettingsViewController: ReactiveBinding {
    typealias Bindable = SettingsViewModel

    func bind(to viewModel: SettingsViewModel) {
        let output = viewModel.transform(input: makeInput())

        output.title
            .drive(rx.title)
            .disposed(by: disposeBag)

        output.title
            .do(onNext: { _ in self.navigationController?.tabBarItem.title = nil })
            .drive()
            .disposed(by: disposeBag)

        output.welcomeMessage
            .filter { !$0.isEmpty }
            .drive(welcomeMessageLabel.rx.text)
            .disposed(by: disposeBag)

        output.welcomeMessage
            .map { !$0.isEmpty }
            .do(onNext: { messageVisible in
                if messageVisible {
                    let maxSize = CGSize(width: self.tableView.bounds.width, height: 200)
                    let size = self.welcomeMessageLabel.sizeThatFits(maxSize)
                    self.welcomeMessageLabel.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height + 30)

                    self.tableView.tableHeaderView = self.welcomeMessageLabel
                }
                else {
                    self.tableView.tableHeaderView = nil
                }
            })
            .drive()
            .disposed(by: disposeBag)

        output.applications
            .drive(tableViewModel.rx.datasource)
            .disposed(by: disposeBag)

        output.navigateToDetails
            .drive()
            .disposed(by: disposeBag)

        output.navigateToDetails
            .map { _ in self.tableView.indexPathForSelectedRow }
            .asObservable()
            .unwrap()
            .subscribe(onNext: { self.tableView.deselectRow(at: $0, animated: true) })
            .disposed(by: disposeBag)
    }

    func makeInput() -> SettingsViewModel.Input {
        return SettingsViewModel.Input(itemSelected: tableView.rx.itemSelected)
    }
}
