//
//  DvrAddShowViewController.swift
//  Down
//
//  Created by Ruud Puts on 27/05/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

import DownKit
import RxSwift
import RxCocoa
import RxResult

class DvrAddShowViewController: UIViewController & Depending {
    let dependencies: Dependencies
    typealias Dependencies = RouterDependency
        & DvrApplicationDependency
        & DvrInteractorFactoryDependency
        & ErrorHandlerDependency

    @IBOutlet weak var searchTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var tableView: UITableView!

    private let viewModel: DvrAddShowViewModel
    private let disposeBag = DisposeBag()

    private var addingShowAlert: UIAlertController?

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

        configureTableView()
        applyStyling()
        applyViewModel()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        searchTextField.becomeFirstResponder()
    }

    private func applyViewModel() {
        title = viewModel.title

        bind(to: viewModel)
    }

    private func applyStyling() {
        view.style(as: .backgroundView)
        navigationController?.navigationBar.style(as: .transparentNavigationBar)
        searchTextField.style(as: .floatingLabelTextField(for: dependencies.dvrApplication.downType))
        tableView.style(as: .defaultTableView)
    }

    private func configureTableView() {
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
}

private extension DvrAddShowViewController {
    func presentAddingShowAlert(for show: DvrShow) {
        let alert = UIAlertController(title: "Adding '\(show.name)'", message: "Please wait while the show is being added", preferredStyle: .alert)

        addingShowAlert = alert
        present(alert, animated: true, completion: nil)
    }

    func dismissAddingShowAlert() {
        addingShowAlert?.dismiss(animated: true, completion: {
            self.addingShowAlert = nil
        })
    }
}

extension DvrAddShowViewController: ReactiveBinding {
    func makeInput() -> DvrAddShowViewModel.Input {
        let showSelected = tableView.rx.itemSelected
        let searchFieldText = searchTextField.rx.debouncedText

        return DvrAddShowViewModel.Input(searchQuery: searchFieldText,
                                         showSelected: showSelected)
    }

    func bind(to viewModel: DvrAddShowViewModel) {
        let output = viewModel.transform(input: makeInput())

        output.searchResults
            .asDriver(onErrorJustReturn: [])
            .drive(tableView.rx.items) { (_, _, show) in
                let cell = UITableViewCell()
                cell.textLabel?.text = show.name
                cell.backgroundColor = .clear
                cell.textLabel?.style(as: .headerLabel)

                return cell
            }
            .disposed(by: disposeBag)

        output.addingShow
            .subscribe(onNext: {
                self.presentAddingShowAlert(for: $0)
            })
            .disposed(by: disposeBag)

        output.showAdded
            .map { _ in self.tableView.indexPathForSelectedRow }
            .unwrap()
            .subscribe(onNext: {
                self.dismissAddingShowAlert()
                self.tableView.deselectRow(at: $0, animated: true)
            })
            .disposed(by: disposeBag)

        output.showAdded
            .do(
                onSuccess: { _ in
                    self.dependencies.router.close(viewController: self)
                },
                onFailure: {
                    self.dependencies.errorHandler.handle(error: $0, action: .dvr_addShow, source: self)
                }
            )
            .subscribe()
            .disposed(by: disposeBag)
    }
}
