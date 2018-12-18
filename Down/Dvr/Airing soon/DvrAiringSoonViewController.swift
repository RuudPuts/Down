//
//  DvrAiringSoonViewController.swift
//  Down
//
//  Created by Ruud Puts on 17/12/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import UIKit
import DownKit
import RxSwift
import RxCocoa

class DvrAiringSoonViewController: UIViewController & Depending {
    typealias Dependencies = RouterDependency
    let dependencies: Dependencies

    @IBOutlet weak var tableView: UITableView!

    private let viewModel: DvrAiringSoonViewModel

    private let disposeBag = DisposeBag()

    init(dependencies: Dependencies, viewModel: DvrAiringSoonViewModel) {
        self.dependencies = dependencies
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
        title = viewModel.title
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension DvrAiringSoonViewController: ReactiveBinding {
    func makeInput() -> DvrAiringSoonViewModel.Input {
        return DvrAiringSoonViewModel.Input()
    }

    func bind(to viewModel: DvrAiringSoonViewModel) {
        let output = viewModel.transform(input: makeInput())

        
    }
}

class DvrAiringSoonCell: UITableViewCell {
}
