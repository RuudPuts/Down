//
//  ResponseMapper.swift
//  Down
//
//  Created by Ruud Puts on 16/05/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

public protocol ResponseMapper {
    associatedtype ResultType
    
    var parser: ResponseParser { get set }
    
    init(parser: ResponseParser)
    func map(storage: DataStoring) -> ResultType
}
