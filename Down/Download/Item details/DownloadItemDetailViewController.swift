//
//  DownloadItemDetailViewController.swift
//  Down
//
//  Created by Ruud Puts on 06/10/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import UIKit
import DownKit

import RxSwift
import RxCocoa

class DownloadItemDetailViewController: UIViewController & Routing & DownloadApplicationInteracting {
    var downloadApplication: DownloadApplication!
    var downloadInteractorFactory: DownloadInteractorProducing!

    var viewModel: DownloadItemDetailViewModel? {
        didSet {
            applyViewModel()
        }
    }
    var router: Router?

    @IBOutlet weak var headerImageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!

    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        applyStyling()
    }

    func applyStyling() {
        view.style(as: .backgroundView)
    }

    func applyViewModel() {
        viewModel?.title
            .bind(to: rx.title)
            .disposed(by: disposeBag)


        let headerImage = viewModel?
            .headerImage
            .skip(1)
        

        headerImage?
            .bind(to: headerImageView.rx.image)
            .disposed(by: disposeBag)

        headerImage?
            .map { $0 == nil }
            .bind(to: headerImageView.rx.isHidden)
            .disposed(by: disposeBag)

        tableView.reloadData()
    }
}
