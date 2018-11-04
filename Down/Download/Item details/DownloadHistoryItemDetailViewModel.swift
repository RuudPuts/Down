//
//  DownloadHistoryItemDetailViewModel.swift
//  Down
//
//  Created by Ruud Puts on 20/10/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import DownKit

class DownloadHistoryItemDetailViewModel: DownloadItemDetailViewModel, Depending {
    typealias Dependencies = DvrRequestBuilderDependency
    let dependencies: Dependencies

    var historyItem: DownloadHistoryItem
    var downloadItem: DownloadItem {
        return historyItem
    }

    init(dependencies: Dependencies, historyItem: DownloadHistoryItem) {
        self.dependencies = dependencies
        self.historyItem = historyItem
    }

    var subtitle: String? {
        return nil
    }

    var headerImageUrl: URL? {
        guard let show = downloadItem.dvrEpisode?.show else {
            return nil
        }

        return dependencies.dvrRequestBuilder.url(for: .fetchPoster(show))
    }

    var statusText: String {
        return historyItem.state.displayName
    }

    var statusStyle: ViewStyling<UILabel> {
        return .historyItemStatusLabel(historyItem.state)
    }

    var itemHasProgress: Bool {
        return historyItem.state.hasProgress
    }

    var itemCanRetry: Bool {
        guard historyItem.state == .failed,
            downloadItem.dvrEpisode != nil else {
                return false
        }

        return true
    }

    func makeItemRows() -> [DownloadItemDetailRow] {
        var rows = [
            DownloadItemDetailRow(key: .nzbname, value: historyItem.name),
            DownloadItemDetailRow(key: .status, value: historyItem.state.displayName),
            DownloadItemDetailRow(key: .totalSize, value: "\(historyItem.sizeMb)")
        ]

        if let finishDate = historyItem.finishDate, historyItem.state == .completed {
            rows.append(DownloadItemDetailRow(key: .completedTime, value: finishDate.dateTimeString))
        }

        return rows
    }
}
