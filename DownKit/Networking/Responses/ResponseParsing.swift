//
//  ResponseParsing.swift
//  Down
//
//  Created by Ruud Puts on 16/05/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

public protocol ResponseParsing { }

enum ParseError: Error, Hashable {
    case noData
    case invalidJson
    case api(message: String)
    case missingData
}

struct ParsedResult<Type> {
    let data: Type?
    let error: String?
}
