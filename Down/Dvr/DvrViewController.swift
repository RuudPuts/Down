//
//  DvrViewController.swift
//  Down
//
//  Created by Ruud Puts on 27/05/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import DownKit
import RxSwift
import RxCocoa
import UIKit

class DvrViewController: UIViewController & Routing & DatabaseConsuming & DvrApplicationInteracting {
    var router: Router?
    var application: DvrApplication!
    var interactorFactory: DvrInteractorProducing!
    var database: DownDatabase!

    @IBOutlet weak var headerView: ApplicationHeaderView!
    @IBOutlet weak var tableView: UITableView!
    
    lazy var interactor = interactorFactory.makeShowCacheRefreshInteractor(for: application)
    let disposeBag = DisposeBag()

    var shows = Variable<[DvrShow]>([])
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureHeaderView()
        configureTableView()
        
        loadDatabase()
        loadData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    func configureHeaderView() {
        headerView.application = application
        headerView.button?.rx.tap
            .subscribe(onNext: { _ in
                self.router?.showSettings(application: self.application)
            })
            .disposed(by: disposeBag)
    }

    func configureTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.rx.modelSelected(DvrShow.self)
            .subscribe(onNext: {
                self.router?.dvrRouter.showDetail(of: $0)
            })
            .disposed(by: disposeBag)
    }
    
    func loadDatabase() {
        database
            .fetchShows()
            .bind(to: tableView.rx.items(cellIdentifier: "Cell", cellType: UITableViewCell.self)) { (_, show, cell) in
                cell.textLabel?.text = show.name
            }
            .disposed(by: disposeBag)
    }
    
    func loadData() {
        interactor
            .observe()
            .subscribe()
            .disposed(by: disposeBag)
    }
}
