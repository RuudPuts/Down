//
//  DvrResponseMapper.swift
//  Down
//
//  Created by Ruud Puts on 17/05/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import Foundation

public protocol DvrResponseMapper: ResponseMapper {
    var dvrParser: DvrResponseParser { get }
}

public extension DvrResponseMapper {
    // swiftlint:disable force_cast
    var dvrParser: DvrResponseParser {
        return parser as! DvrResponseParser
    }
}
