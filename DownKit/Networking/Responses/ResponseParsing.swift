//
//  ResponseParsing.swift
//  Down
//
//  Created by Ruud Puts on 16/05/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

public protocol ResponseParsing {
    var application: ApiApplication { get }
    init(application: ApiApplication)
    
    func parseImage(from response: Response) throws -> UIImage
}

struct ParsedResult<Type> {
    let data: Type?
    let error: String?
}

extension ResponseParsing {
    func parse(_ response: Response) throws -> String {
        guard let data = response.data else {
            throw ResponseParsingError.noData
        }

        return String(data: data, encoding: .utf8) ?? ""
    }

    func parseImage(from response: Response) throws -> UIImage {
        guard let data = response.data, let image = UIImage(data: data) else {
            throw ResponseParsingError.invalidData
        }

        return image
    }
}
