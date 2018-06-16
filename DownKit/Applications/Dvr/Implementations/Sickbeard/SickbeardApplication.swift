//
//  SickbeardApplication.swift
//  Down
//
//  Created by Ruud Puts on 03/06/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

public class SickbeardApplication: DvrApplication {
    public var name: String = "Sickbeard"
    public var host: String
    public var apiKey: String
    
    public var requestBuilder: RequestBuilding { return dvrRequestBuilder }
    public var responseParser: ResponseParsing { return dvrResponseParser }
    
    public required init(host: String, apiKey: String) {
        self.host = host
        self.apiKey = apiKey
    }
    
    public var dvrRequestBuilder: DvrRequestBuilding {
        return SickbeardRequestBuilder(application: self)
    }
    
    public var dvrResponseParser: DvrResponseParsing {
        return SickbeardResponseParser()
    }
}
