//
//  ViewController.swift
//  Down
//
//  Created by Ruud Puts on 27/05/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import DownKit
import RxSwift
import RxCocoa
import UIKit

class ViewController: UITableViewController & Routing & DatabaseConsuming & DvrApplicationInteracting {
    var application: DvrApplication!
    var interactorFactory: DvrInteractorProducing!
    var database: DownDatabase!
    var router: Router?
    
    lazy var interactor = interactorFactory.makeShowCacheRefreshInteractor(for: application)
    let disposeBag = DisposeBag()

    var shows = Variable<[DvrShow]>([])
    
    required init?(coder aDecoder: NSCoder) {
        super.init(style: .grouped)
        title = "Show list"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.rx.modelSelected(DvrShow.self)
            .subscribe(onNext: {
                self.router?.showDetail(of: $0)
            })
            .disposed(by: disposeBag)
        
        loadDatabase()
        loadData()
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
