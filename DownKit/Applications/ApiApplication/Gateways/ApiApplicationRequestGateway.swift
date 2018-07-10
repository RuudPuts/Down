//
//  ApiApplicationRequestGateway.swift
//  Down
//
//  Created by Ruud Puts on 22/06/2018
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

protocol ApiApplicationRequestGateway: RequestGateway {
    var builder: ApiApplicationRequestBuilding { get }
    var executor: RequestExecuting { get }
    var parser: ApiApplicationResponseParsing { get }
    
    init(builder: ApiApplicationRequestBuilding, parser: ApiApplicationResponseParsing, executor: RequestExecuting)
}
