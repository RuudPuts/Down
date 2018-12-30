//
//  DvrResponseParsing.swift
//  Down
//
//  Created by Ruud Puts on 18/05/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

public protocol DvrResponseParsing: ApiApplicationResponseParsing {
    func parseShows(from response: Response) throws -> [DvrShow]
    func parseShowDetails(from response: Response) throws -> DvrShow
    func parseSearchShows(from response: Response) throws -> [DvrShow]
    func parseAddShow(from response: Response) throws -> Bool
    func parseDeleteShow(from response: Response) throws -> Bool
    func parseSetEpisodeStatus(from response: Response) throws -> Bool
    func parseSetSeasonStatus(from response: Response) throws -> Bool
    func parseEpisodeDetails(for episode: DvrEpisode, from response: Response) throws -> DvrEpisode
}
