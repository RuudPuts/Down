//
//  DvrRequestGateway.swift
//  Down
//
//  Created by Ruud Puts on 03/06/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

protocol DvrRequestGateway: RequestGateway {
    var builder: DvrRequestBuilding { get }
    var executor: RequestExecuting { get }
    var parser: DvrResponseParsing { get }
    
    init(builder: DvrRequestBuilding, parser: DvrResponseParsing, executor: RequestExecuting)
}
