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

class DetailViewController: UIViewController & Routing & DvrApplicationInteracting {
    var application: DvrApplication!
    var interactorFactory: DvrInteractorProducing!
    var router: Router?
    
    lazy var interactor = interactorFactory.makeShowDetailsInteractor(for: application, show: show!)
    let disposeBag = DisposeBag()
    
    var show: DvrShow? {
        didSet { title = show?.name }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        interactor
            .observe()
            .subscribe(onNext: { (show) in
                NSLog("Refreshed show: \(show.name)")
            })
            .disposed(by: disposeBag)
    }
}
