//
//  ApiApplicationResponseParsing.swift
//  Down
//
//  Created by Ruud Puts on 10/07/2018
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

public protocol ApiApplicationResponseParsing: ResponseParsing {
    func parseLoggedIn(from response: Response) throws -> LoginResult
    func parseApiKey(from response: Response) throws -> String?
}
