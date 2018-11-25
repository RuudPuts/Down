//
//  ApiApplicationResponseParsing.swift
//  Down
//
//  Created by Ruud Puts on 10/07/2018
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import Result

public protocol ApiApplicationResponseParsing: ResponseParsing {
    func parseLoggedIn(from response: Response) -> Result<LoginResult, DownKitError>
    func parseApiKey(from response: Response) -> Result<String?, DownKitError>
}
