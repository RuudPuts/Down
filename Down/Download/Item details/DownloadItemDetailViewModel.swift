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

class DownloadItemDetailViewModel: DvrApplicationInteracting {
    var title: BehaviorRelay<String>
    var headerImage: BehaviorRelay<UIImage?>

    var items: [DownloadItemDetailModel]?

    var dvrApplication: DvrApplication!
    var dvrInteractorFactory: DvrInteractorProducing!

    let disposeBag = DisposeBag()

    init(item: DownloadQueueItem) {
        title = BehaviorRelay(value: item.displayName)
        headerImage = BehaviorRelay(value: nil)

        if let episode = item.dvrEpisode {
            let banner = AssetStorage.banner(for: episode.show)

            if banner == nil {
                fetchBanner(for: episode.show)
            }
            else {
                headerImage.accept(banner)
            }
        }
    }

    func makeItems() {
        items?.append(DownloadItemDetailModel(name: "a", value: "b"))
    }

    func fetchBanner(for show: DvrShow) {
        dvrInteractorFactory
            .makeShowBannerInteractor(for: dvrApplication, show: show)
            .observe()
            .subscribe(onNext: {
                self.headerImage.accept($0)
            })
            .disposed(by: disposeBag)
    }
}

struct DownloadItemDetailModel {
    let name: String
    let value: String
}
