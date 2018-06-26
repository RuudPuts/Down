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
    var type: ApplicationType { get }
}

public enum ApplicationType {
    case download
    case dvr
    case dmr
}
