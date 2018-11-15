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

struct DownloadViewModel: Depending {
    typealias Dependencies = DownloadInteractorFactoryDependency & DownloadApplicationDependency
    let dependencies: Dependencies

    private var refreshInterval: TimeInterval = 2

    private let disposeBag = DisposeBag()
    
    let queueData = Variable(DownloadQueue())
    let sectionsData: Variable<[TableSectionData]> = Variable([])
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies

        startRefreshing()
    }

    func itemAt(indexPath: IndexPath) -> DownloadItem? {
        return sectionsData
            .value[safe: indexPath.section]?
            .items[safe: indexPath.row]
    }
}

private extension DownloadViewModel {
    func startRefreshing() {
        let observables = [refreshQueue(), refreshHistory()]
        Single.zip(observables)
            .asObservable()
            .withInterval(interval: refreshInterval)
            .subscribe(onNext: {
                self.updateSectionData(queue: $0.first, history: $0.last)
            })
            .disposed(by: disposeBag)
    }

    func refreshQueue() -> Single<[DownloadItem]> {
        return dependencies.downloadInteractorFactory
            .makeQueueInteractor(for: dependencies.downloadApplication)
            .observe()
            .do(onSuccess: { self.queueData.value = $0 })
            .map { $0.items }
    }

    func refreshHistory() -> Single<[DownloadItem]> {
        return dependencies.downloadInteractorFactory
            .makeHistoryInteractor(for: dependencies.downloadApplication)
            .observe()
    }

    func updateSectionData(queue: [DownloadItem]? = nil, history: [DownloadItem]? = nil) {
        sectionsData.value = [
            TableSectionData(header: "Queue", icon: R.image.icon_queue(), items: queue ?? []),
            TableSectionData(header: "History", icon: R.image.icon_history(), items: history ?? [])
        ]
    }
}
