//
//  DvrShowDetailViewController.swift
//  Down
//
//  Created by Ruud Puts on 03/06/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import DownKit
import RxSwift
import UIKit

class DvrShowDetailViewController: UIViewController & Routing & DvrApplicationInteracting {
    var application: DvrApplication!
    var interactorFactory: DvrInteractorProducing!
    var router: Router?

    @IBOutlet weak var headerView: DvrShowHeaderView?

    private let disposeBag = DisposeBag()

    var show: DvrShow? {
        didSet {
            configureHeaderView()

            checkShowBanner()
            checkShowPoster()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        applyStyling()
        configureHeaderView()
    }
    
    func applyStyling() {
        view.style(as: .backgroundView)
        navigationController?.navigationBar.style(as: .transparentNavigationBar)
    }

    func configureHeaderView() {
        headerView?.model = DvrShowHeaderViewModel(show: show!)
    }

    func checkShowBanner() {
        guard let show = show, let application = application,
            AssetStorage.banner(for: show) == nil else {
            return
        }

        interactorFactory
            .makeShowBannerInteractor(for: application, show: show)
            .observe()
            .subscribe(onNext: { _ in
                self.configureHeaderView()
            })
            .disposed(by: disposeBag)    }

    func checkShowPoster() {
        guard let show = show, let application = application,
            AssetStorage.poster(for: show) == nil else {
            return
        }

        interactorFactory
            .makeShowPosterInteractor(for: application, show: show)
            .observe()
            .subscribe(onNext: { _ in
                self.configureHeaderView()
            })
            .disposed(by: disposeBag)
    }
}
