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
    var router: Router!

    // DownKit
    var database: DownDatabase

    var applicationAdditionsFactory: ApplicationAdditionsProducing

    var apiGatewayFactory: ApiApplicationGatewayProducing!
    var apiInteractorFactory: ApiApplicationInteractorProducing!

    var downloadApplication: DownloadApplication!
    var downloadGatewayFactory: DownloadGatewayProducing!
    var downloadInteractorFactory: DownloadInteractorProducing!

    var dvrApplication: DvrApplication!
    var dvrGatewayFactory: DvrGatewayProducing!
    var dvrInteractorFactory: DvrInteractorProducing!
    var dvrRequestBuilder: DvrRequestBuilding!

    var dmrApplication: DmrApplication!
    var dmrGatewayFactory: DmrGatewayProducing!
    var dmrInteractorFactory: DmrInteractorProducing!

    init() {
        persistence = UserDefaults.standard
        database = RealmDatabase.default

        applicationAdditionsFactory = ApplicationAdditionsFactory()

        reloadApplication(.download)
        reloadApplication(.dvr)
        reloadApplication(.dmr)

        apiGatewayFactory = ApiApplicationGatewayFactory(dependencies: self)
        apiInteractorFactory = ApiApplicationInteractorFactory(dependencies: self)

        downloadGatewayFactory = DownloadGatewayFactory(dependencies: self)
        downloadInteractorFactory = DownloadInteractorFactory(dependencies: self)

        dvrGatewayFactory = DvrGatewayFactory(dependencies: self)
        dvrInteractorFactory = DvrInteractorFactory(dependencies: self)

        dmrGatewayFactory = DmrGatewayFactory(dependencies: self)
        dmrInteractorFactory = DmrInteractorFactory(dependencies: self)
    }

    func reloadApplication(_ type: ApiApplicationType) {
        switch type {
        case .download: downloadApplication = persistence.load(type: .sabnzbd) as? DownloadApplication
        case .dvr:
            dvrRequestBuilder = nil
            dvrApplication = persistence.load(type: .sickbeard) as? DvrApplication

            if let application = dvrApplication {
                dvrRequestBuilder = applicationAdditionsFactory.makeDvrRequestBuilder(for: application)
            }
        case .dmr: dmrApplication = persistence.load(type: .couchpotato) as? DmrApplication
        }
    }
}

typealias AllDownDependencies = DownKitDependencies
    & ApplicationPersistenceDependency
    & RouterDependency

protocol ApplicationPersistenceDependency {
    var persistence: ApplicationPersisting { get }
}

protocol RouterDependency {
    var router: Router! { get set }
}
