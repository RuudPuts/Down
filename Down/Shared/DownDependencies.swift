//
//  DownDependencies.swift
//  Down
//
//  Created by Ruud Puts on 04/11/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import DownKit

class DownDependencies: ApplicationPersistenceDependency {
    var persistence: ApplicationPersisting

    // router
    // applications
    // api interacting
    // download interaccting
    // dvr interacting
    // dmr interacting

    init(persistence: ApplicationPersisting) {
        self.persistence = persistence
    }
}

protocol ApplicationPersistenceDependency {
    var persistence: ApplicationPersisting { get }
}
