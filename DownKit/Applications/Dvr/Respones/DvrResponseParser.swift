//
//  DvrResponseParser.swift
//  Down
//
//  Created by Ruud Puts on 18/05/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

protocol DvrResponseParser: ResponseParser {
    func parseShows(from storage: DataStoring) -> [DvrShow]
    func parseShow(from storage: DataStoring) -> DvrShow
}
