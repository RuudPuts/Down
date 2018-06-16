//
//  ApiApplicationMock.swift
//  DownKitTests
//
//  Created by Ruud Puts on 14/06/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

@testable import DownKit

class ApiApplicationMock: ApiApplication {
    struct Stubs {
        var name = "ApiApplication"
        var host = "ApiHost"
        var apiKey = "ApiKey"
        var requestBuilder: RequestBuilding = RequestBuildingMock()
        var responseParser: ResponseParser = ResponseParserMock()
    }
    
    struct Captures {
        var `init`: Init?
        
        struct Init {
            var host: String
            var apiKey: String
        }
    }
    
    var stubs = Stubs()
    var captures = Captures()
    
    convenience init() {
        self.init(host: "ApiHost", apiKey: "ApiKey")
        
        stubs.host = host
        stubs.apiKey = apiKey
    }
    
    // ApiApplication
    
    var name: String { return stubs.name }
    var host: String { return stubs.host }
    var apiKey: String { return stubs.host }
    var requestBuilder: RequestBuilding { return stubs.requestBuilder }
    var responseParser: ResponseParser { return stubs.responseParser }
    
    required init(host: String, apiKey: String) {
        captures.init = Captures.Init(host: host, apiKey: apiKey)
    }
}
