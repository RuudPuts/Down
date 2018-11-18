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
        var type = ApiApplicationType.dvr
        var name = "ApiApplication"
        var host = "ApiHost"
        var apiKey = "ApiKey"
        var requestBuilder: RequestBuilding?
        var responseParser: ResponseParsing?
    }
    
    struct Captures {
        var `init`: Init?
        var host: String?
        var apiKey: String?
        
        struct Init {
            var host: String
            var apiKey: String
        }
    }
    
    var stubs = Stubs()
    var captures = Captures()
    
    // ApiApplication
    var type: ApiApplicationType { return stubs.type }
    var name: String { return stubs.name }
    var host: String {
        get { return stubs.host }
        set { captures.host = host }
    }
    var apiKey: String {
        get { return stubs.apiKey }
        set { captures.host = host }
    }

    var requestBuilder: RequestBuilding {
        return stubs.requestBuilder!
    }
    var responseParser: ResponseParsing {
        return stubs.responseParser!
    }
    
    required init(host: String, apiKey: String) {
        captures.init = Captures.Init(host: host, apiKey: apiKey)
    }

    convenience init() {
        self.init(host: "ApiHost", apiKey: "ApiKey")

        stubs.host = host
        stubs.apiKey = apiKey
    }

    func copy() -> Any {
        return self
    }
}
