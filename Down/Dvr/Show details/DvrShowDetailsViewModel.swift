//
//  DvrShowDetailsViewModel.swift
//  Down
//
//  Created by Ruud Puts on 15/11/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import DownKit
import RxSwift
import UIKit

class DvrShowDetailsViewModel: Depending {
    typealias Dependencies = DvrInteractorFactoryDependency & DvrRequestBuilderDependency
    let dependencies: Dependencies

    let show: DvrShow

    init(dependencies: Dependencies, show: DvrShow) {
        self.dependencies = dependencies
        self.show = show
    }

    func deleteShow() -> Observable<Bool> {
        return dependencies.dvrInteractorFactory
            .makeDeleteShowInteractor(for: dependencies.dvrApplication, show: show)
            .observe()
    }

    var bannerUrl: URL? {
        return dependencies.dvrRequestBuilder.url(for: .fetchBanner(show))
    }

    var posterUrl: URL? {
        return dependencies.dvrRequestBuilder.url(for: .fetchPoster(show))
    }
}
