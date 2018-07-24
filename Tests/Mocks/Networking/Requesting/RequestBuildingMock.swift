//
//  RequestBuildingMock.swift
//  DownKitTests
//
//  Created by Ruud Puts on 14/06/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

@testable import DownKit
import RxSwift

class RequestBuildingMock: RequestBuilding {
    var application: ApiApplication

    required init(application: ApiApplication) {
        self.application = application
    }
}
