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
    var title = R.string.localizable.download_screen_root_title()
    var refreshInterval: TimeInterval = 2

    let queueInteractor: DownloadQueueInteractor
    let historyInteractor: DownloadHistoryInteractor
    let disposeBag = DisposeBag()
    
    let queueData = Variable(DownloadQueue())
    let sectionsData: Variable<[DownloadSectionData]> = Variable([])
    
    init(queueInteractor: DownloadQueueInteractor, historyInteractor: DownloadHistoryInteractor) {
        self.queueInteractor = queueInteractor
        self.historyInteractor = historyInteractor

        startRefreshing()
    }
}

private extension DownloadViewModel {
    func startRefreshing() {
        let observables = [refreshQueue(), refreshHistory()]
        Observable.zip(observables)
            .withInterval(interval: refreshInterval)
            .subscribe(onNext: {
                self.updateSectionData(queue: $0.first, history: $0.last)
            })
            .disposed(by: disposeBag)
    }

    func refreshQueue() -> Observable<[DownloadItem]> {
        return queueInteractor
            .observe()
            .do(onNext: { self.queueData.value = $0 })
            .map { $0.items }
    }

    func refreshHistory() -> Observable<[DownloadItem]> {
        return historyInteractor.observe()
    }

    func updateSectionData(queue: [DownloadItem]? = nil, history: [DownloadItem]? = nil) {
        sectionsData.value = [
            DownloadSectionData(header: "Queue", items: queue ?? []),
            DownloadSectionData(header: "History", items: history ?? [])
        ]
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
