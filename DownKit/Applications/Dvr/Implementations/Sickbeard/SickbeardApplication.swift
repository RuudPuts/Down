//
//  SickbeardApplication.swift
//  Down
//
//  Created by Ruud Puts on 03/06/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

class SickbeardAplication: DvrApplication {
    var name: String = "Sickbeard"
    var host: String
    var apiKey: String
    
    var requestBuilder: RequestBuilding { return dvrRequestBuilder }
    var responseParser: ResponseParser { return dvrResponseParser }
    
    required init(host: String, apiKey: String) {
        self.host = host
        self.apiKey = apiKey
    }
    
    var dvrRequestBuilder: DvrRequestBuilding {
        return SickbeardRequestBuilder(application: self)
    }
    
    var dvrResponseParser: DvrResponseParser {
        return SickbeardResponseParser()
    }
}
