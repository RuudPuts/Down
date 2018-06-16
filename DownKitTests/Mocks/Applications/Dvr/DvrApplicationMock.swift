//
//  DvrApplicationMock.swift
//  DownKitTests
//
//  Created by Ruud Puts on 14/06/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

@testable import DownKit

class DvrApplicationMock: ApiApplicationMock, DvrApplication {
    var dvrRequestBuilder: DvrRequestBuilding {
        // swiftlint:disable force_cast
        return stubs.requestBuilder as! DvrRequestBuilding
    }
    
    var dvrResponseParser: DvrResponseParsing {
        // swiftlint:disable force_cast
        return stubs.responseParser as! DvrResponseParsing
    }
}
