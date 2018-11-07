//
//  SickbeardResponseParser.swift
//  Down
//
//  Created by Ruud Puts on 16/05/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import SwiftyJSON

class SickgearResponseParser: SickbeardResponseParser {
    override func parseLoggedIn(from response: Response) throws -> LoginResult {
        //! Might want to check http response code 😅
        guard let data = response.data else {
            throw ParseError.noData
        }

        let response = String(data: data, encoding: .utf8) ?? ""
        let loginFormStart = "<div class=\"login\">"

        return response.range(of: loginFormStart) == nil ? .success : .authenticationRequired
    }
}
