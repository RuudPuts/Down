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

class DvrAddShowViewController: UIViewController & Routing & DatabaseConsuming & DvrApplicationInteracting {
    var application: DvrApplication!
    var interactorFactory: DvrInteractorProducing!
    var database: DownDatabase!
    var router: Router?

    @IBOutlet weak var searchTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var tableView: UITableView!

    let disposeBag = DisposeBag()

    lazy var viewModel = DvrAddShowViewModel(application: application,
                                             database: database,
                                             interactorFactory: interactorFactory)
    
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

    func configureSearchTextField() {
        searchTextField.rx.text
            .skip(2)
            .debounce(0.3, scheduler: MainScheduler.instance)
            .subscribe(onNext: { query in
                self.viewModel
                    .searchShows(query: query ?? "")
                    .bind(to: self.tableView.rx.items(cellIdentifier: "Cell", cellType: UITableViewCell.self)) { (_, show, cell) in
                        cell.textLabel?.text = show.name

                        cell.backgroundColor = .clear
                        cell.textLabel?.style(as: .headerLabel)
                    }
                    .disposed(by: self.disposeBag)
            })
            .disposed(by: disposeBag)
    }

    func configureTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        tableView.rx.modelSelected(DvrShow.self)
            .subscribe(onNext: {
                self.viewModel
                    .add(show: $0)
                    .subscribe(onNext: { _ in
                        self.router?.close(viewController: self)
                    })
                    .disposed(by: self.disposeBag)
            })
            .disposed(by: disposeBag)
    }

    func applyViewModel() {
        title = viewModel.title
    }

    func applyStyling() {
        view.style(as: .backgroundView)
        searchTextField.style(as: .textField(for: application.downType))
        navigationController?.navigationBar.style(as: .transparentNavigationBar)
    }
}
