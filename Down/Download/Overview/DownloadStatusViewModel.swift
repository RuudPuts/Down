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
import Result
import RxResult

struct DownloadStatusViewModel: Depending {
    typealias Dependencies = DownloadInteractorFactoryDependency & DownloadApplicationDependency
    let dependencies: Dependencies

    let activityViewText = "Fetching status..." //! localize

    var input = Input()
    lazy var output = transform(input: input)

    fileprivate let refreshInterval: TimeInterval = 2

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
}

extension DownloadStatusViewModel: ReactiveBindable {
    struct Input {
        let itemSelected = PublishSubject<IndexPath>()
        let pauseQueue = PublishSubject<Void>() //! Signal?
        let resumeQueue = PublishSubject<Void>()
        let purgeHistory = PublishSubject<Void>()
    }

    struct Output {
        let queue: Driver<DownloadQueue>
        let sectionsData: Driver<[TableSectionData<DownloadItem>]>
        let itemSelected: Observable<DownloadItem>

        let queuePaused: Observable<Result<Bool, DownError>>
        let queueResumed: Observable<Result<Bool, DownError>>
        let historyPurged: Observable<Result<Bool, DownError>>
    }
}

extension DownloadStatusViewModel {
    func transform(input: Input) -> Output {
        let queuePaused = input.pauseQueue.flatMap { self.makePauseQueueInteractor() }
        let queueResumed = input.resumeQueue.flatMap { self.makeResumeQueueInteractor() }

        let historyPurged = input.purgeHistory.flatMap { self.makePurgeHistoryInteractor() }

        let queue = makeQueueDriver()
        let history = makeHistoryDriver()
        let sectionsData = makeSectionDataDriver(queueItems: queue.map { $0.items },
                                                 historyItems: history)

        let itemSelected = input.itemSelected
            .withLatestFrom(sectionsData) { indexPath, sections in
                return sections[indexPath.section].items[indexPath.row]
        }

        return Output(queue: queue, sectionsData: sectionsData, itemSelected: itemSelected,
                      queuePaused: queuePaused, queueResumed: queueResumed, historyPurged: historyPurged)
    }

    private func makeSectionDataDriver(queueItems: Driver<[DownloadItem]>, historyItems: Driver<[DownloadItem]>) -> Driver<[TableSectionData<DownloadItem>]> {
        return Driver.zip([queueItems, historyItems])
            .map {[
                TableSectionData(header: "Queue",
                                 icon: R.image.icon_queue(),
                                 items: $0.first ?? [],
                                 emptyMessage: "Your queue is empty"),
                TableSectionData(header: "History",
                                 icon: R.image.icon_history(),
                                 items: $0.last ?? [],
                                 emptyMessage: "Your history is empty")
            ]}
    }

    private func makeQueueDriver() -> Driver<DownloadQueue> {
        return dependencies.downloadInteractorFactory
            .makeQueueInteractor(for: dependencies.downloadApplication)
            .observe()
            .asObservable()
            .withInterval(interval: refreshInterval)
            .asDriver(onErrorJustReturn: DownloadQueue())
    }

    private func makePauseQueueInteractor() -> Observable<Result<Bool, DownError>> {
        return dependencies.downloadInteractorFactory
            .makePauseQueueInteractor(for: dependencies.downloadApplication)
            .observeResult()
    }

    private func makeResumeQueueInteractor() -> Observable<Result<Bool, DownError>> {
        return dependencies.downloadInteractorFactory
            .makeResumeQueueInteractor(for: dependencies.downloadApplication)
            .observeResult()
    }

     func makeHistoryDriver() -> Driver<[DownloadItem]> {
        return dependencies.downloadInteractorFactory
            .makeHistoryInteractor(for: dependencies.downloadApplication)
            .observe()
            .asObservable()
            .withInterval(interval: refreshInterval)
            .asDriver(onErrorJustReturn: [])
    }

    private func makePurgeHistoryInteractor() -> Observable<Result<Bool, DownError>> {
        return dependencies.downloadInteractorFactory
            .makePurgeHistoryInteractor(for: dependencies.downloadApplication)
            .observeResult()
    }
}
