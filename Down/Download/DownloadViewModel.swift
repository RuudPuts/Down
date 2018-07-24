//
//  DownloadViewModel.swift
//  Down
//
//  Created by Ruud Puts on 25/06/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import DownKit
import RxSwift
import RxDataSources

struct DownloadViewModel {
    var title = R.string.localizable.screen_download_root_title()
    var refreshInterval: TimeInterval = 2
    
    let queueInteractor: DownloadQueueInteractor
    let historyInteractor: DownloadHistoryInteractor
    let disposeBag = DisposeBag()
    
    let queueData = Variable(DownloadQueue())
    let sectionsData = Variable([DownloadSectionData(header: "Queue", items: []), DownloadSectionData(header: "History", items: [])])
    
    init(queueInteractor: DownloadQueueInteractor, historyInteractor: DownloadHistoryInteractor) {
        self.queueInteractor = queueInteractor
        self.historyInteractor = historyInteractor

        loadQueue()
        loadHistory()
    }
}

private extension DownloadViewModel {
    //! Should this just be a driver instead?
    // Note queue & history shoudl still be running together
    func loadQueue() {
        queueInteractor
            .observe()
//            .withInterval(interval: refreshInterval)
            .subscribe(onNext: { queue in
                self.queueData.value = queue
                self.updateSection(0, withItems: queue.items)
            })
            .disposed(by: disposeBag)
    }
    
    func loadHistory() {
        historyInteractor
            .observe()
//            .withInterval(interval: refreshInterval)
            .subscribe(onNext: { items in
                self.updateSection(1, withItems: items)
            })
            .disposed(by: disposeBag)
    }

    //! This method causes a UI glitch since it is mutating sectonsData and both Queue and History will call it at the same time
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
