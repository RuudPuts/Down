//
//  ApplicationSettingsViewController.swift
//  Down
//
//  Created by Ruud Puts on 14/07/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import DownKit

class ApplicationSettingsViewController: UIViewController & Routing {
    var application: ApiApplication!
    var router: Router?
    let disposeBag = DisposeBag()

    @IBOutlet weak var hostTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var apiKeyTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var headerView: ApplicationHeaderView!

    override func viewDidLoad() {
        super.viewDidLoad()

//        Driver.just(application).drive
        headerView.application = application as? DownApplication
        
        headerView.button?.setImage(AssetProvider.icons.close, for: .normal)
        headerView.button?.rx.tap
            .subscribe(onNext: { _ in
                self.router?.close(viewController: self)
            })
            .disposed(by: disposeBag)

        hostTextField.text = application.host
        apiKeyTextField.text = application.apiKey
    }

}
