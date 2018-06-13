//
//  ApiApplication.swift
//  Down
//
//  Created by Ruud Puts on 06/01/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

protocol ApiCall { }

protocol ApiApplication: Application {
    var host: String { get }
    var apiKey: String { get }
    
    var requestBuilder: RequestBuilding { get }
    var responseParser: ResponseParser { get }
    
    init(host: String, apiKey: String)
}
