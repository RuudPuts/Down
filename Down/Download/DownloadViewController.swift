//
//  DownloadViewController.swift
//  Down
//
//  Created by Ruud Puts on 27/05/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import UIKit
import DownKit

class DownloadViewController: UITableViewController & DownloadRouting & DatabaseConsuming & DownloadApplicationInteracting {
    var application: DownloadApplication!
    var interactorFactory: DownloadInteractorProducing!
    var database: DownDatabase!
    var downloadRouter: DownloadRouter?
    
    lazy var viewModel = DownloadViewModel(tableView: tableView, application: application, interactorFactory: interactorFactory)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = viewModel.title
    }
}
