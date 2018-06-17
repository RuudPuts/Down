//
//  Application.swift
//  Down
//
//  Created by Ruud Puts on 04/01/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

public protocol Application {
    var name: String { get }
    var type: ApplicationType { get }
}

public enum ApplicationType {
    case dvr
}
