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

class DmrStatusViewController: UIViewController & Depending {
    public typealias Dependencies = DmrApplicationDependency
    public let dependencies: Dependencies

    private var disposeBag: DisposeBag!

    @IBOutlet weak var headerView: ApplicationHeaderView!

    init(dependencies: Dependencies) {
        self.dependencies = dependencies

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

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

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        disposeBag = nil
    }

    private func applyStyling() {
        view.style(as: .backgroundView)
        headerView.style(as: .headerView(for: dependencies.dmrApplication.downType))
    }
}
