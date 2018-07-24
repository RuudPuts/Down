//
//  DvrApplicationRefreshCacheAction.swift
//  Down
//
//  Created by Ruud Puts on 24/07/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import DownKit

class DvrApplicationRefreshCacheAction: ApplicationSettingsChangedAction {
    typealias Interactor = DvrRefreshShowCacheInteractor

    var title: String
    var interactor: DvrRefreshShowCacheInteractor

    required init(title: String = "Refreshing show cache...", interactor: DvrRefreshShowCacheInteractor) {
        self.title = title
        self.interactor = interactor
    }
}
