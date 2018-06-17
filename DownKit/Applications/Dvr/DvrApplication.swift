//
//  DvrApplication.swift
//  Down
//
//  Created by Ruud Puts on 04/01/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

//! Dvr application should be the implementing class
//! When the app starts it'll load some kind of config file, i.e.
//! - applications:
//!   - dvr:
//!     - sickbeard
//!       - host: 192.168.1.100:8081
//!       - apikey: 1234567890
//!   - download:
//!     - sabnzbd
//!       - host: 192.168.1.100:8080
//!       - apikey: 1234567890
//!   - dmr:
//!     - couchpotato
//!       - host: 192.168.1.100:5050
//!       - apikey: 1234567890
//!
//! So there will be an enum somewhere to define all these
//! And a factory which creates the applications for UI level

//! Another factory, something internal to DownKit could then be responsible for creating the reques builders, mappers & parsers
//! This factory could be used by a gateway factory to set the builder & mapper, hopefully removing this awefull GatewayConfiguration protocol as well

public class DvrApplication: ApiApplication {
    public var name = "DvrApplication"
    public var type = ApplicationType.dvr
    public var dvrType: DvrApplicationType
    
    public var host: String
    public var apiKey: String
    
    init(type: DvrApplicationType, host: String, apiKey: String) {
        self.dvrType = type
        self.host = host
        self.apiKey = apiKey
    }
}

public enum DvrApplicationType: String {
    case sickbeard = "Sickbeard"
}

public enum DvrApplicationCall {
    case showList
    case showDetails(DvrShow)
}

extension DvrApplicationCall: Hashable {
    public var hashValue: Int {
        switch self {
        case .showList:
            return 0
        case .showDetails(let show):
            return Int("1\(show.name.hashValue)") ?? 1
        }
    }
    
    public static func == (lhs: DvrApplicationCall, rhs: DvrApplicationCall) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
}
