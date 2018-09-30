//
//  DmrApplication.swift
//  Down
//
//  Created by Ruud Puts on 30/09/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

public class DmrApplication: ApiApplication {
    public var name = "DmrApplication"
    public var type = ApiApplicationType.dmr
    public var dmrType: DmrApplicationType
    
    public var host: String
    public var apiKey: String
    
    public init(type: DmrApplicationType, host: String, apiKey: String) {
        self.dmrType = type
        self.host = host
        self.apiKey = apiKey
    }

    public func copy() -> Any {
        return DmrApplication(type: dmrType, host: host, apiKey: apiKey)
    }
}

public enum DmrApplicationType: String {
    case couchpotato = "CouchPotato"
}

public enum DmrApplicationCall {
    case movieList
}

extension DmrApplicationCall: Hashable {
    public var hashValue: Int {
        switch self {
        case .movieList:
            return 0
        }
    }
    
    public static func == (lhs: DmrApplicationCall, rhs: DmrApplicationCall) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
}
