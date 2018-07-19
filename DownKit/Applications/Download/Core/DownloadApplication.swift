//
//  DownloadApplication.swift
//  Down
//
//  Created by Ruud Puts on 22/06/2018
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

public class DownloadApplication: ApiApplication {
    public var name = "DownloadApplication"
    public var type = ApiApplicationType.download
    public var downloadType: DownloadApplicationType {
        didSet {
            name = downloadType.rawValue
        }
    }
    
    public var host: String
    public var apiKey: String
    
    public init(type: DownloadApplicationType, host: String, apiKey: String) {
        self.downloadType = type
        self.host = host
        self.apiKey = apiKey
    }

    public func copy() -> Any {
        return DownloadApplication(type: downloadType, host: host, apiKey: apiKey)
    }
}

public enum DownloadApplicationType: String {
    case sabnzbd
}

public enum DownloadApplicationCall: String {
    case queue
    case history
}
