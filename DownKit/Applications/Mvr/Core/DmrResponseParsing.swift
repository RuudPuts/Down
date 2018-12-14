//
//  DmrResponseParsing.swift
//  Down
//
//  Created by Ruud Puts on 30/09/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

public protocol DmrResponseParsing: ApiApplicationResponseParsing {
    func parseMovies(from response: Response) throws -> [DmrMovie]
}
