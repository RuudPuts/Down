//
//  SabNZBdRequestBuilder.swift
//  Down
//
//  Created by Ruud Puts on 22/06/2018
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

class SabNZBdRequestBuilder: DownloadRequestBuilding {
    var application: DownloadApplication
    
    required init(application: DownloadApplication) {
        self.application = application
    }
    
    func path(for apiCall: DownloadApplicationCall) -> String? {
        return "api?mode=\(apiCall.rawValue)&output=json&apikey={apikey}&limit=30"
    }
    
    func method(for apiCall: DownloadApplicationCall) -> Request.Method {
        return .get
    }
}
