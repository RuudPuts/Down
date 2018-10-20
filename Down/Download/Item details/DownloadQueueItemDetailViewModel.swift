//
//  DownloadQueueItemDetailViewModel.swift
//  Down
//
//  Created by Ruud Puts on 20/10/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import DownKit

class DownloadQueueItemDetailViewModel: DownloadItemDetailViewModel {
    var queueItem: DownloadQueueItem
    var downloadItem: DownloadItem {
        return queueItem
    }

    var downloadApplication: DownloadApplication!
    var downloadInteractorFactory: DownloadInteractorProducing!

    var dvrApplication: DvrApplication!
    var dvrInteractorFactory: DvrInteractorProducing!

    init(queueItem: DownloadQueueItem) {
        self.queueItem = queueItem
    }

    var subtitle: String? {
        return nil
    }

    var statusText: String {
        return queueItem.state.displayName
    }

    var statusStyle: ViewStyling<UILabel> {
        return .queueItemStatusLabel(queueItem.state)
    }

    func makeItemRows() -> [DownloadItemDetailRow] {
        return [
            DownloadItemDetailRow(key: .nzbname, value: queueItem.name),
            DownloadItemDetailRow(key: .status, value: queueItem.state.displayName),
            DownloadItemDetailRow(key: .totalSize, value: "\(queueItem.sizeMb)"),
            DownloadItemDetailRow(key: .sizeLeft, value: "\(queueItem.sizeMb)"),
            DownloadItemDetailRow(key: .timeLeft, value: "\(queueItem.sizeMb)")
        ]
    }

    var itemHasProgress: Bool {
        return true
    }

    var itemCanRetry: Bool {
        return false
    }
}
