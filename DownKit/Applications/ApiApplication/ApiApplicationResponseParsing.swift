//
//  ApiApplicationResponseParsing.swift
//  Down
//
//  Created by Ruud Puts on 10/07/2018
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

public protocol ApiApplicationResponseParsing: ResponseParsing {
    func parseLoggedIn(from storage: DataStoring) throws -> Bool
    func parseApiKey(from storage: DataStoring) throws -> String?
}
