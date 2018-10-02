//
//  DmrStatusViewController.swift
//  Down
//
//  Created by Ruud Puts on 30/09/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import DownKit
import RxSwift
import RxCocoa
import UIKit

class DmrStatusViewController: UIViewController & Routing & DmrApplicationInteracting {
    var application: DmrApplication!
    var router: Router?

    let disposeBag = DisposeBag()

    @IBOutlet weak var headerView: ApplicationHeaderView!

    override func viewDidLoad() {
        super.viewDidLoad()

        applyStyling()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if let navigationController = navigationController,
            navigationController.viewControllers.count > 1 {
            navigationController.setNavigationBarHidden(false, animated: animated)
        }
    }

    func applyStyling() {
        view.style(as: .backgroundView)
        headerView.style(as: .headerView(for: application.downType))
    }
}
