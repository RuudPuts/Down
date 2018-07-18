//
//  DvrResponseParsing.swift
//  Down
//
//  Created by Ruud Puts on 18/05/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

public protocol DvrResponseParsing: ResponseParsing {
    func parseShows(from response: Response) throws -> [DvrShow]
    func parseShowDetails(from response: Response) throws -> DvrShow
}
