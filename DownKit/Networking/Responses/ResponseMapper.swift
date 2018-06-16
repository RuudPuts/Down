//
//  ResponseMapper.swift
//  Down
//
//  Created by Ruud Puts on 16/05/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

public protocol ResponseMapper {
    associatedtype ResultType
    
    var parser: ResponseParsing { get set }
    
    init(parser: ResponseParsing)
    func map(storage: DataStoring) -> ResultType
}
