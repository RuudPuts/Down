//
//  DownKitDependencies.swift
//  DownKit
//
//  Created by Ruud Puts on 04/11/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

public protocol Depending {
    associatedtype Dependencies
    var dependencies: Dependencies { get }
}

public typealias DownKitDependencies = DatabaseDependency

public protocol DatabaseDependency {
    var database: DownDatabase { get set }
}
