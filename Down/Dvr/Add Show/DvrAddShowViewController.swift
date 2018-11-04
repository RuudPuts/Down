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

class DvrAddShowViewController: UIViewController & Depending, DvrApplicationInteracting {
    typealias Dependencies = RouterDependency// & DatabaseDependency
    let dependencies: Dependencies

    var dvrApplication: DvrApplication!
    var dvrInteractorFactory: DvrInteractorProducing!

    @IBOutlet weak var searchTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var tableView: UITableView!

    let disposeBag = DisposeBag()

    lazy var viewModel = DvrAddShowViewModel(/*dependencies: dependencies,*/
                                             application: dvrApplication,
                                             interactorFactory: dvrInteractorFactory)

    init(dependencies: Dependencies) {
        self.dependencies = dependencies

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
                        self.dependencies.router.close(viewController: self)
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
        searchTextField.style(as: .textField(for: dvrApplication.downType))
        navigationController?.navigationBar.style(as: .transparentNavigationBar)
    }
}
