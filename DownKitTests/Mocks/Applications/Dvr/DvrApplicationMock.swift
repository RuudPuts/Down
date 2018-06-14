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
        return stubs.requestBuilder as! DvrRequestBuilding
    }
    
    var dvrResponseParser: DvrResponseParser {
        return stubs.responseParser as! DvrResponseParser
    }
}
