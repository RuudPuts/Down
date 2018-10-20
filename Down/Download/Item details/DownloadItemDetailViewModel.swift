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

protocol DownloadItemDetailViewModel: DvrApplicationInteracting {
    var title: String { get }
    var subtitle: String? { get }
    var statusText: String { get }
    var statusStyle: ViewStyling<UILabel> { get }

    var downloadItem: DownloadItem { get }
    var items: [[DownloadItemDetailModel]]? { get }

    var itemHasProgress: Bool { get }
    var itemCanRetry: Bool { get }
}

extension DownloadItemDetailViewModel {
    func fetchHeaderImage() -> Driver<UIImage?> {
        guard let show = downloadItem.dvrEpisode?.show else {
            return Single.just(nil).asDriver(onErrorJustReturn: nil)
        }

        return dvrInteractorFactory
            .makeShowPosterInteractor(for: dvrApplication, show: show)
            .observe()
            .map { $0 as UIImage?}
            .asDriver(onErrorJustReturn: nil)
    }
}

class DownloadQueueItemDetailViewModel: DownloadItemDetailViewModel {
    var title: String
    var subtitle: String?
    var statusText: String
    var statusStyle: ViewStyling<UILabel>

    var downloadItem: DownloadItem {
        return queueItem
    }
    var queueItem: DownloadQueueItem
    var items: [[DownloadItemDetailModel]]?

    var dvrApplication: DvrApplication!
    var dvrInteractorFactory: DvrInteractorProducing!

    init(queueItem: DownloadQueueItem) {
        self.queueItem = queueItem

        title = queueItem.displayName

        statusText = queueItem.state.displayName
        statusStyle = .queueItemStatusLabel(queueItem.state)
    }

    func makeItems() {
        let firstSection = [
            DownloadItemDetailModel(key: .nzbname, value: downloadItem.displayName)
            // status
            // mb total
            // mb left
            // timeleft
        ]

        // show stuf

        items?.append(firstSection)
    }

    var itemHasProgress: Bool {
        return true
    }

    var itemCanRetry: Bool {
        return false
    }
}

class DownloadHistoryItemDetailViewModel: DownloadItemDetailViewModel {
    var title: String
    var subtitle: String?
    var statusText: String
    var statusStyle: ViewStyling<UILabel>

    var downloadItem: DownloadItem {
        return historyItem
    }
    var historyItem: DownloadHistoryItem
    var items: [[DownloadItemDetailModel]]?

    var dvrApplication: DvrApplication!
    var dvrInteractorFactory: DvrInteractorProducing!

    init(historyItem: DownloadHistoryItem) {
        self.historyItem = historyItem

        title = historyItem.displayName

        statusText = historyItem.state.displayName
        statusStyle = .historyItemStatusLabel(historyItem.state)
    }

    func makeItems() {
        let firstSection = [
            DownloadItemDetailModel(key: .nzbname, value: downloadItem.displayName)
            // status
            // time finishd opt
        ]

        // show stuf

        items?.append(firstSection)
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
}

enum DownloadItemDetailKey {
        case nzbname
        case status
        case progress
        case totalSize

        // Queue specific
        case mbProgress

        // History specific
        case finishedAt
        case postProcessingOutput

        // Dvr
        case showName
        case episodeNumber
        case episodeName
        case episodeAirdate
        case episodePlot
}

struct DownloadItemDetailModel {
    let key: DownloadItemDetailKey
    let value: String
}
