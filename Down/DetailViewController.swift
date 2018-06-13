//
//  DetailViewController.swift
//  Down
//
//  Created by Ruud Puts on 03/06/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import DownKit
import RxSwift
import UIKit

class DetailViewController: UIViewController & Routing {
    let disposeBag = DisposeBag()
    var router: Router?
    
//    var show: DvrShow? {
//        didSet { title = show?.name }
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//
//        guard let show = show else {
//            return
//        }
//
//        let application = RXRequest.dvrApplication
//        let configFactory = DvrGatewayConfigurationFactory(application: application)
//        let gateway = ShowDetailsGateway(config: configFactory.make(), show: show)
//
//        do {
//            try gateway
//                .get()
//                .subscribe(onNext: { (show) in
//                    NSLog("Refreshed show: \(show.name)")
//                })
//                .disposed(by: disposeBag)
//        }
//        catch {
//            NSLog("Error while executing ShowListGateway: \(error)")
//        }
//    }
}
