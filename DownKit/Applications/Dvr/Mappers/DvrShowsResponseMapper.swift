//
//  DvrShowsResponseMapper.swift
//  Down
//
//  Created by Ruud Puts on 28/05/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

public final class DvrShowsResponseMapper: DvrResponseMapper {
    public typealias ResultType = [DvrShow]
    
    public var parser: ResponseParser
    
    public init(parser: ResponseParser) {
        self.parser = parser
    }
    
    public func map(storage: DataStoring) -> ResultType {
        return dvrParser.parseShows(from: storage)
    }
}
