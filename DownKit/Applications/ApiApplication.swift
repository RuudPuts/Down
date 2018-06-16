//
//  ApiApplication.swift
//  Down
//
//  Created by Ruud Puts on 06/01/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

public protocol ApiApplication: Application {
    var host: String { get }
    var apiKey: String { get }
    
    //! ApiApplication should not store these. RequestBuilding also needs ApiApplication -> Reference cycle
    var requestBuilder: RequestBuilding { get }
    var responseParser: ResponseParser { get }
    
    init(host: String, apiKey: String)
}
