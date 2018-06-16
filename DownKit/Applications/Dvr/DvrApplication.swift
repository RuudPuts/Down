//
//  DvrApplication.swift
//  Down
//
//  Created by Ruud Puts on 04/01/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

public protocol DvrApplication: ApiApplication {
    var dvrResponseParser: DvrResponseParsing { get }
    var dvrRequestBuilder: DvrRequestBuilding { get }
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
