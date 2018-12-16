//
//  DownKitDependenciesStub.swift
//  Down
//
//  Created by Ruud Puts on 09/11/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

@testable import DownKit

class DownKitDependenciesStub: DownKitDependencies {
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
        database = DownDatabaseMock()

        applicationAdditionsFactory = ApplicationAdditionsProducingMock()

        downloadApplication = DownloadApplication(type: .sabnzbd, host: "", apiKey: "")
        dvrApplication = DvrApplication(type: .sickbeard, host: "", apiKey: "")
        dmrApplication = DmrApplication(type: .couchpotato, host: "", apiKey: "")

        apiGatewayFactory = ApiApplicationGatewayFactory(dependencies: self)
        apiInteractorFactory = ApiApplicationInteractorFactory(dependencies: self)

        downloadGatewayFactory = DownloadGatewayFactory(dependencies: self)
        downloadInteractorFactory = DownloadInteractorFactory(dependencies: self)

        dvrGatewayFactory = DvrGatewayFactory(dependencies: self)
        dvrInteractorFactory = DvrInteractorFactory(dependencies: self)

        dmrGatewayFactory = DmrGatewayFactory(dependencies: self)
        dmrInteractorFactory = DmrInteractorFactory(dependencies: self)
    }
}

extension DownKitDependenciesStub {
    // swiftlint:disable force_cast
    var databaseMock: DownDatabaseMock {
        return database as! DownDatabaseMock
    }

    var applicationAdditionsFactoryMock: ApplicationAdditionsProducingMock {
        return applicationAdditionsFactory as! ApplicationAdditionsProducingMock
    }
    // swiftlint:enable force_cast
}
