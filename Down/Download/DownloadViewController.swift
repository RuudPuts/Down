//
//  DownloadViewController.swift
//  Down
//
//  Created by Ruud Puts on 27/05/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import UIKit
import DownKit
import RxSwift
import RxCocoa
import RxDataSources

class DownloadViewController: UIViewController & Routing & DatabaseConsuming & DownloadApplicationInteracting {
    var application: DownloadApplication!
    var interactorFactory: DownloadInteractorProducing!
    var database: DownDatabase!
    var router: Router?
    let disposeBag = DisposeBag()

    @IBOutlet weak var headerView: ApplicationHeaderView!
    @IBOutlet weak var statusView: DownloadQueueStatusView!
    @IBOutlet weak var tableView: UITableView!
    
    lazy var viewModel = DownloadViewModel(queueInteractor: interactorFactory.makeQueueInteractor(for: application),
                                           historyInteractor: interactorFactory.makeHistoryInteractor(for: application))
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureHeaderView()
        configureTableView()
        applyViewModel()
    }

    func configureHeaderView() {
        headerView.set(application: application)
        headerView.button?.rx.tap
            .subscribe(onNext: { _ in
                self.router?.showSettings(application: self.application)
            })
            .disposed(by: disposeBag)
    }
    
    func configureTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        dataSource.titleForHeaderInSection = { dataSource, index in
            return dataSource.sectionModels[index].header
        }
    }
    
    func applyViewModel() {
        title = viewModel.title

        viewModel.queueData.asDriver().drive(statusView.rx.queue).disposed(by: disposeBag)
        viewModel.sectionsData
            .asDriver()
            .drive(tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }

    let dataSource = RxTableViewSectionedReloadDataSource<DownloadSectionData>(configureCell: { (_, tableView, indexPath, item) -> UITableViewCell in
        let cell = tableView.dequeueReusableCell(withIdentifier: DownloadItemCell.identifier, for: indexPath)
        // Can't call any methods or variables from here for some reason.
        // Error: Value of type '(DownloadViewController) -> () -> (DownloadViewController)' has no member '<called ref>'
        // Code should move to view model
        (cell as? DownloadItemCell)?.viewModel = DownloadItemCellModel(item: item)

        return cell
    })
}
