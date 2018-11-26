//
//  ResponseParsing.swift
//  Down
//
//  Created by Ruud Puts on 16/05/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import Result

public protocol ResponseParsing {
    var application: ApiApplication { get }
    init(application: ApiApplication)
    
    func parseImage(from response: Response) -> Result<UIImage, DownKitError>
}

struct ParsedResult<Type> {
    let data: Type?
    let error: String?
}

extension ResponseParsing {
    func parse(_ response: Response) -> Result<String, DownKitError> {
        guard let data = response.data else {
            return .failure(.responseParsing(.noData))
        }

        return .success(String(data: data, encoding: .utf8) ?? "")
    }

    func parseImage(from response: Response) -> Result<UIImage, DownKitError> {
        guard let data = response.data, let image = UIImage(data: data) else {
            return .failure(.responseParsing(.invalidData))
        }

        return .success(image)
    }
}
