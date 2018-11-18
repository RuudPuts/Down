//
//  ResponseParsingMock.swift
//  DownKitTests
//
//  Created by Ruud Puts on 25/05/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

@testable import DownKit

class ResponseParsingMock: ResponseParsing {
    var application: ApiApplication

    required init(application: ApiApplication) {
        self.application = application
    }

    convenience init() {
        self.init(application: ApiApplicationMock())
    }
}
