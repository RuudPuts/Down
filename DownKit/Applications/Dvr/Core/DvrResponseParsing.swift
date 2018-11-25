//
//  DvrResponseParsing.swift
//  Down
//
//  Created by Ruud Puts on 18/05/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import Result

public protocol DvrResponseParsing: ApiApplicationResponseParsing {
    func parseShows(from response: Response) -> Result<[DvrShow], DownKitError>
    func parseShowDetails(from response: Response) -> Result<DvrShow, DownKitError>
    func parseSearchShows(from response: Response) -> Result<[DvrShow], DownKitError>
    func parseAddShow(from response: Response) -> Result<Bool, DownKitError>
    func parseDeleteShow(from response: Response) -> Result<Bool, DownKitError>
    func parseSetEpisodeStatus(from response: Response) -> Result<Bool, DownKitError>
    func parseSetSeasonStatus(from response: Response) -> Result<Bool, DownKitError>
}
