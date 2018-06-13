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

class ViewController: UITableViewController & Routing {
//    let application: DvrApplication
//    let configFactory: DvrGatewayConfigurationFactory
//    let gateway: ShowListGateway
    var router: Router?
    
    let disposeBag = DisposeBag()
    
//    var shows = Variable<[DvrShow]>([])
    
    required init?(coder aDecoder: NSCoder) {
//        application = RXRequest.dvrApplication
//        configFactory = DvrGatewayConfigurationFactory(application: application)
//        gateway = ShowListGateway(config: configFactory.make())
        
        super.init(style: .grouped)
        title = "Show list"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
//        tableView.rx.modelSelected(DvrShow.self)
//            .subscribe(onNext: {
//                self.router?.showDetail(of: $0)
//            })
//            .disposed(by: disposeBag)
        
        loadData()
    }
    
    func loadData() {
//        do {
//            try gateway
//                .get()
//                .do(onError: { (error) in
//                    print("ErrorVC: \(error)")
//                })
//                .bind(to: tableView.rx.items(cellIdentifier: "Cell", cellType: UITableViewCell.self)) { (_, show, cell) in
//                    cell.textLabel?.text = show.name
//                }
//                .disposed(by: disposeBag)
//        }
//        catch {
//            NSLog("Error while executing ShowListGateway: \(error)")
//        }
    }
}
