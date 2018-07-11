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

class DvrViewController: UIViewController & DvrRouting & DatabaseConsuming & DvrApplicationInteracting {
    var application: DvrApplication!
    var interactorFactory: DvrInteractorProducing!
    var database: DownDatabase!
    var dvrRouter: DvrRouter?

    @IBOutlet weak var headerView: ApplicationHeaderView!
    @IBOutlet weak var tableView: UITableView!
    
    lazy var interactor = interactorFactory.makeShowCacheRefreshInteractor(for: application)
    let disposeBag = DisposeBag()

    var shows = Variable<[DvrShow]>([])
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        title = "Show list"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureHeaderView()
        configureTableView()
        
        loadDatabase()
        loadData()
    }

    func configureHeaderView() {
        headerView.set(application: application)
        headerView.button?.rx.tap
            .subscribe(onNext: { _ in
                self.dvrRouter?.showSettings()
            })
            .disposed(by: disposeBag)
    }

    func configureTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.rx.modelSelected(DvrShow.self)
            .subscribe(onNext: {
                self.dvrRouter?.showDetail(of: $0)
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
