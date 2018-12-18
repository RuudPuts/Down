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
        let navigateToDetails: Observable<DownloadItem>
    }

    func transform(input: Input) -> Output {
        let queueDriver = dependencies.downloadInteractorFactory
            .makeQueueInteractor(for: dependencies.downloadApplication)
            .observe()
            .asDriver(onErrorJustReturn: DownloadQueue())

        let queueItemsDriver = queueDriver.map { $0.items }

        let historyDriver = dependencies.downloadInteractorFactory
            .makeHistoryInteractor(for: dependencies.downloadApplication)
            .observe()
            .asDriver(onErrorJustReturn: [])

        let sectionsDriver = Driver.zip([queueItemsDriver, historyDriver])
            .asObservable()
//            .withInterval(interval: refreshInterval)
            .map {[
                TableSectionData(header: "Queue", icon: R.image.icon_queue(), items: $0.first ?? []),
                TableSectionData(header: "History", icon: R.image.icon_history(), items: $0.last ?? [])
            ]}
            .asDriver(onErrorJustReturn: [])

        let navigateDetailsDriver = input.itemSelected
            .withLatestFrom(sectionsDriver) { indexPath, sections in
                return sections[indexPath.section].items[indexPath.row]
            }

        return Output(queue: queueDriver,
                      sectionsData: sectionsDriver,
                      navigateToDetails: navigateDetailsDriver)
    }
}
