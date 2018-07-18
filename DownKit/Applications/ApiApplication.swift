//
//  ApiApplication.swift
//  Down
//
//  Created by Ruud Puts on 06/01/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

public protocol ApiApplication: Application {
    var host: String { get set }
    var apiKey: String { get set }
    var type: ApiApplicationType { get }
}

public enum ApiApplicationType {
    case download
    case dvr
//    case dmr
}

public enum ApiApplicationCall {
    case login
    case apiKey
}
