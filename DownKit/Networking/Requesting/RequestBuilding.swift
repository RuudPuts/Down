//
//  RequestBuilding.swift
//  Down
//
//  Created by Ruud Puts on 08/01/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

public protocol RequestBuilding { }

enum RequestBuildingError: Error {
    case notSupportedError(String)
}

extension RequestBuildingError: Hashable {
    public var hashValue: Int {
        switch self {
        case .notSupportedError(let message):
            return Int("1\(message.hashValue)") ?? 1
        }
    }
    
    public static func == (lhs: RequestBuildingError, rhs: RequestBuildingError) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
}
