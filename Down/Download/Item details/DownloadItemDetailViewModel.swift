//
//  DownloadItemDetailViewModel.swift
//  Down
//
//  Created by Ruud Puts on 06/10/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import UIKit
import DownKit
import RxSwift
import RxCocoa
import Result

struct DownloadItemDetailViewModel: Depending {
    typealias Dependencies = DownloadInteractorFactoryDependency & DvrRequestBuilderDependency
    let dependencies: Dependencies

    let item: DownloadItem

    init(dependencies: Dependencies, item: DownloadItem) {
        self.dependencies = dependencies
        self.item = item
    }
}

extension DownloadItemDetailViewModel: ReactiveBindable {
    struct Input {
        let deleteButtonTapped: ControlEvent<Void>
    }

    struct Output {
        let refinedItem: Driver<RefinedItem>
        let itemDeleted: Observable<Result<Void, DownError>>
    }

    func transform(input: Input) -> Output {
        let refinedItem = RefinedItem.from(item: item, withDvrRequestBuilder: dependencies.dvrRequestBuilder)
        let refinedItemDriver = Driver<RefinedItem>.just(refinedItem)

        let itemDeletedDriver = input.deleteButtonTapped
            .flatMap { _ in
                self.dependencies.downloadInteractorFactory
                    .makeDeleteItemInteractor(for: self.dependencies.downloadApplication, item: self.item)
                    .observeResult()
            }
            .map { $0.map { _ in } }

        return Output(refinedItem: refinedItemDriver, itemDeleted: itemDeletedDriver)
    }
}

extension DownloadItemDetailViewModel {
    struct RefinedItem {
        let title: String
        let subtitle: String?

        let headerImageUrl: URL?

        let statusText: String
        let statusStyle: ViewStyling<UILabel>

        let hasProgress: Bool
        let progress: Double
        let canRetry: Bool

        let detailSections: [[DownloadItemDetailRow]]

        static func from(item: DownloadItem, withDvrRequestBuilder requestBuilder: DvrRequestBuilding) -> RefinedItem {
            if let queueItem = item as? DownloadQueueItem {
                return RefinedItem.from(queueItem: queueItem, withDvrRequestBuilder: requestBuilder)
            }
            else if let historyItem = item as? DownloadHistoryItem {
                return RefinedItem.from(historyItem: historyItem, withDvrRequestBuilder: requestBuilder)
            }
            else {
                fatalError("Unkown DownloadItemType")
            }
        }

        static func from(queueItem: DownloadQueueItem, withDvrRequestBuilder requestBuilder: DvrRequestBuilding) -> RefinedItem {
            var headerImageUrl: URL?
            if let show = queueItem.dvrEpisode?.show {
                headerImageUrl = requestBuilder.url(for: .fetchPoster(show))
            }

            let detailSections = [
                    [
                        DownloadItemDetailRow(key: .nzbname, value: queueItem.name),
                        DownloadItemDetailRow(key: .status, value: queueItem.state.displayName),
                        DownloadItemDetailRow(key: .totalSize, value: String.displayString(forMb: queueItem.sizeMb)),
                        DownloadItemDetailRow(key: .sizeLeft, value: String.displayString(forMb: queueItem.remainingMb)),
                        DownloadItemDetailRow(key: .timeLeft, value: queueItem.remainingTime.displayString)
                    ],
                    makeDvrEpisodeRows(for: queueItem)
                ].compactMap { $0 }

            return RefinedItem(title: queueItem.displayName,
                               subtitle: nil,
                               headerImageUrl: headerImageUrl,
                               statusText: queueItem.state.displayName,
                               statusStyle: .queueItemStatusLabel(queueItem.state),
                               hasProgress: true,
                               progress: queueItem.progress,
                               canRetry: false,
                               detailSections: detailSections)
        }

        static func from(historyItem: DownloadHistoryItem, withDvrRequestBuilder requestBuilder: DvrRequestBuilding) -> RefinedItem {
            var headerImageUrl: URL?
            if let show = historyItem.dvrEpisode?.show {
                headerImageUrl = requestBuilder.url(for: .fetchPoster(show))
            }

            var detailRows = [
                DownloadItemDetailRow(key: .nzbname, value: historyItem.name),
                DownloadItemDetailRow(key: .status, value: historyItem.state.displayName),
                DownloadItemDetailRow(key: .totalSize, value: String.displayString(forMb: historyItem.sizeMb))
            ]

            if let finishDate = historyItem.finishDate, historyItem.state == .completed {
                detailRows.append(DownloadItemDetailRow(key: .completedTime, value: finishDate.dateTimeString))
            }

            let detailSections = [detailRows, makeDvrEpisodeRows(for: historyItem)].compactMap { $0 }

            let canRetry = historyItem.state == .failed && historyItem.dvrEpisode != nil

            return RefinedItem(title: historyItem.displayName,
                               subtitle: nil,
                               headerImageUrl: headerImageUrl,
                               statusText: historyItem.state.displayName,
                               statusStyle: .historyItemStatusLabel(historyItem.state),
                               hasProgress: historyItem.state.hasProgress,
                               progress: historyItem.progress,
                               canRetry: canRetry,
                               detailSections: detailSections)
        }

        private static func makeDvrEpisodeRows(for item: DownloadItem) -> [DownloadItemDetailRow]? {
            guard let episode = item.dvrEpisode,
                let show = item.dvrEpisode?.show else {
                    return nil
            }

            return [
                DownloadItemDetailRow(key: .showName, value: show.name),
                DownloadItemDetailRow(key: .episodeNumber, value: episode.seasonIdentifierString ?? "-"),
                DownloadItemDetailRow(key: .episodeName, value: episode.name),
                DownloadItemDetailRow(key: .episodeAirdate, value: episode.airdate?.dateString ?? "-")
            ]
        }
    }
}
