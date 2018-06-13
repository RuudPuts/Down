//
//  DvrShowsResponseMapper.swift
//  Down
//
//  Created by Ruud Puts on 28/05/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

final class DvrShowsResponseMapper: DvrResponseMapper {
    typealias ResultType = [DvrShow]
    
    var parser: ResponseParser
    
    init(parser: ResponseParser) {
        self.parser = parser
    }
    
    func map(storage: DataStoring) -> ResultType {
        return dvrParser.parseShows(from: storage)
    }
}
