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
    var errorHandler: ErrorHandling
    var notificationService: NotificationService

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
        database = RealmDatabase()
        errorHandler = ErrorHandler()
        notificationService = BoxcarService()

        applicationAdditionsFactory = ApplicationAdditionsFactory()

        ApiApplicationType.allCases.forEach {
            reloadApplication($0)
        }

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
        let application = persistence.load(type: type)

        switch type {
        case .download: downloadApplication = application as? DownloadApplication
        case .dvr:
            dvrRequestBuilder = nil
            dvrApplication = application as? DvrApplication

            if let application = dvrApplication {
                dvrRequestBuilder = applicationAdditionsFactory.makeDvrRequestBuilder(for: application)
            }
        case .dmr: dmrApplication = application as? DmrApplication
        }
    }
}

typealias AllDownDependencies = DownKitDependencies
    & ApplicationPersistenceDependency
    & RouterDependency
    & ErrorHandlerDependency
    & NotificationServiceDependency

protocol ApplicationPersistenceDependency {
    var persistence: ApplicationPersisting { get }
}

protocol RouterDependency {
    var router: Router! { get set }
}

protocol ErrorHandlerDependency {
    var errorHandler: ErrorHandling { get set }
}
