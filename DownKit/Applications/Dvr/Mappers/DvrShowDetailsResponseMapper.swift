//
//  DvrShowDetailsResponseMapper.swift
//  Down
//
//  Created by Ruud Puts on 28/05/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

public final class DvrShowDetailsResponseMapper: DvrResponseMapper {
    public typealias ResultType = DvrShow
    
    public var parser: ResponseParsing
    
    public init(parser: ResponseParsing) {
        self.parser = parser
    }
    
    public func map(storage: DataStoring) -> ResultType {
        return dvrParser.parseShowDetails(from: storage)
    }
}
