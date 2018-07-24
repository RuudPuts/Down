//
//  ApplicationSettingsChangedActionFactory.swift
//  Down
//
//  Created by Ruud Puts on 24/07/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import DownKit

protocol ApplicationSettingsChangedActionProducing {
    func makeDvrRefreshCacheAction(for application: DvrApplication) -> DvrApplicationRefreshCacheAction
}

class ApplicationSettingsChangedActionFactory: ApplicationSettingsChangedActionProducing {
    let dvrInteractorFactory: DvrInteractorProducing

    init(dvrInteractorFactory: DvrInteractorProducing) {
        self.dvrInteractorFactory = dvrInteractorFactory
    }

    func makeDvrRefreshCacheAction(for application: DvrApplication) -> DvrApplicationRefreshCacheAction {
        let interactor = dvrInteractorFactory.makeShowCacheRefreshInteractor(for: application)

        return DvrApplicationRefreshCacheAction(interactor: interactor)
    }
}
