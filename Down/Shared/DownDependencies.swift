//
//  DownDependencies.swift
//  Down
//
//  Created by Ruud Puts on 04/11/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import DownKit

class DownDependencies: AllDownDependencies {
    var persistence: ApplicationPersisting
    var viewControllerFactory: ViewControllerProducing!
    var router: Router!

    // DownKit
    var database: DownDatabase

    // router
    // applications
    // api interacting
    // download interaccting
    // dvr interacting
    // dmr interacting

    init() {
        persistence = UserDefaults.standard
        database = RealmDatabase.default
    }

    static func recursiveInit() -> DownDependencies {
        let dependencies = DownDependencies()

        //! Ehm..
        dependencies.viewControllerFactory = ViewControllerFactory(dependencies: dependencies)

        return dependencies
    }
}

typealias AllDownDependencies = DownKitDependencies
    & ApplicationPersistenceDependency
    & ViewControllerFactoryDependency
    & RouterDependency

protocol ApplicationPersistenceDependency {
    var persistence: ApplicationPersisting { get }
}

protocol ViewControllerFactoryDependency {
    var viewControllerFactory: ViewControllerProducing! { get }
}

protocol RouterDependency {
    var router: Router! { get set }
}
