//
//  DvrAddShowViewController.swift
//  Down
//
//  Created by Ruud Puts on 27/05/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import DownKit
import RxSwift
import RxCocoa
import UIKit
import SkyFloatingLabelTextField

class DvrAddShowViewController: UIViewController & Depending {
    typealias Dependencies = RouterDependency & DvrApplicationDependency & DvrInteractorFactoryDependency
    let dependencies: Dependencies

    @IBOutlet weak var searchTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var tableView: UITableView!

    private let viewModel: DvrAddShowViewModel
    private let disposeBag = DisposeBag()

    init(dependencies: Dependencies, viewModel: DvrAddShowViewModel) {
        self.dependencies = dependencies
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureSearchTextField()
        configureTableView()
        applyStyling()
        applyViewModel()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        searchTextField.becomeFirstResponder()
    }

    private func configureSearchTextField() {
        searchTextField.rx.text
            .skip(2)
            .debounce(0.3, scheduler: MainScheduler.instance)
            .flatMap { self.viewModel.searchShows(query: $0 ?? "") }
            .bind(to: self.tableView.rx.items(cellIdentifier: "Cell", cellType: UITableViewCell.self)) { (_, show, cell) in
                cell.textLabel?.text = show.name

                cell.backgroundColor = .clear
                cell.textLabel?.style(as: .headerLabel)
            }
            .disposed(by: self.disposeBag)
    }

    private func configureTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        tableView.rx.modelSelected(DvrShow.self)
            .do(onNext: { _ in
                if let indexPath = self.tableView.indexPathForSelectedRow {
                    self.tableView.deselectRow(at: indexPath, animated: true)
                }
            })
            .flatMap { self.viewModel.add(show: $0) }
            .subscribe(onNext: { _ in
                self.dependencies.router.close(viewController: self)
            })
            .disposed(by: disposeBag)

        tableView.rx.willDisplayCell
            .subscribe { event in
                switch event {
                case .next(let cell, _):
                    let type = self.dependencies.dvrApplication.downType
                    cell.style(as: .selectableCell(application: type))
                default:
                    break
                }
            }
            .disposed(by: disposeBag)
    }

    private func applyViewModel() {
        title = viewModel.title
    }

    private func applyStyling() {
        view.style(as: .backgroundView)
        searchTextField.style(as: .textField(for: dependencies.dvrApplication.downType))
        navigationController?.navigationBar.style(as: .transparentNavigationBar)
    }
}
