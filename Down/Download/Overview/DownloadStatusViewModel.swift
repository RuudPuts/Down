//
//  DownloadStatusViewModel.swift
//  Down
//
//  Created by Ruud Puts on 25/06/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import DownKit
import RxSwift
import RxCocoa

struct DownloadStatusViewModel: Depending {
    typealias Dependencies = DownloadInteractorFactoryDependency & DownloadApplicationDependency
    let dependencies: Dependencies

    let activityViewText = "Fetching status..."

    private var refreshInterval: TimeInterval = 2

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
}

extension DownloadStatusViewModel: ReactiveBindable {
    struct Input {
        let itemSelected: ControlEvent<IndexPath>
    }

    struct Output {
        let queue: Driver<DownloadQueue>
        let sectionsData: Driver<[TableSectionData<DownloadItem>]>
        let itemSelected: Observable<DownloadItem>
    }

    func transform(input: Input) -> Output {
        let queue = dependencies.downloadInteractorFactory
            .makeQueueInteractor(for: dependencies.downloadApplication)
            .observe()
            .asDriver(onErrorJustReturn: DownloadQueue())

        let queueItems = queue.map { $0.items }

        let history = dependencies.downloadInteractorFactory
            .makeHistoryInteractor(for: dependencies.downloadApplication)
            .observe()
            .asDriver(onErrorJustReturn: [])

        let sectionsData = Driver.zip([queueItems, history])
            .asObservable()
            .withInterval(interval: refreshInterval)
            .map {[
                TableSectionData(header: "Queue", icon: R.image.icon_queue(), items: $0.first ?? []),
                TableSectionData(header: "History", icon: R.image.icon_history(), items: $0.last ?? [])
            ]}
            .asDriver(onErrorJustReturn: [])

        let itemSelected = input.itemSelected
            .withLatestFrom(sectionsData) { indexPath, sections in
                return sections[indexPath.section].items[indexPath.row]
            }

        return Output(queue: queue,
                      sectionsData: sectionsData,
                      itemSelected: itemSelected)
    }
}
