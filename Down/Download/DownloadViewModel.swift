//
//  DownloadViewModel.swift
//  Down
//
//  Created by Ruud Puts on 25/06/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import UIKit
import DownKit
import RxSwift
import RxCocoa
import RxDataSources

class DownloadViewModel: DownloadApplicationInteracting {
    var title: String = "Downloads"
    var refreshInterval: TimeInterval = 2
    
    let tableView: UITableView
    var application: DownloadApplication!
    var interactorFactory: DownloadInteractorProducing!
    
    lazy var queueInteractor = interactorFactory.makeQueueInteractor(for: application)
    lazy var historyInteractor = interactorFactory.makeHistoryInteractor(for: application)
    let disposeBag = DisposeBag()
    
    let sectionsData = Variable<[DownloadSectionData]>([DownloadSectionData(header: "Queue", items: []), DownloadSectionData(header: "History", items: [])])
    let dataSource = RxTableViewSectionedReloadDataSource<DownloadSectionData>(configureCell: { (_, tableView, indexPath, item) -> UITableViewCell in
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        if let episode = item.dvrEpisode {
            cell.textLabel?.text = "\(episode.show.name) - S\(episode.season.identifier)E\(episode.identifier) - \(episode.name)"
        }
        else {
            cell.textLabel?.text = item.name
        }
        
        return cell
    })
    
    init(tableView: UITableView, application: DownloadApplication, interactorFactory: DownloadInteractorProducing) {
        self.tableView = tableView
        self.application = application
        self.interactorFactory = interactorFactory
        
        configureTableView()
        dataSource.titleForHeaderInSection = { dataSource, index in
            return dataSource.sectionModels[index].header
        }
        sectionsData.asObservable()
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        loadQueue()
        loadHistory()
    }
    
    func configureTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    func loadQueue() {
        queueInteractor
            .observe()
            .withInterval(interval: refreshInterval)
            .subscribe(onNext: { queue in
                self.updateSection(0, withItems: queue.items)
            })
            .disposed(by: disposeBag)
    }
    
    func loadHistory() {
        historyInteractor
            .observe()
            .withInterval(interval: refreshInterval)
            .subscribe(onNext: { items in
                self.updateSection(1, withItems: items)
            })
            .disposed(by: disposeBag)
    }
    
    func updateSection(_ index: Int, withItems items: [DownloadSectionData.Item]) {
        let section = DownloadSectionData(original: sectionsData.value[index], items: items)
        sectionsData.value.remove(at: index)
        sectionsData.value.insert(section, at: index)
    }
}

struct DownloadSectionData: SectionModelType {
    typealias Item = DownloadItem
    
    var header: String
    var items: [Item]
    
    init(header: String, items: [Item]) {
        self.header = header
        self.items = items
    }
    
    init(original: DownloadSectionData, items: [Item]) {
        self = original
        self.items = items
    }
}
