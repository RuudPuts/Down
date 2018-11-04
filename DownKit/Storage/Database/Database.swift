//
//  Database.swift
//  DownKit
//
//  Created by Ruud Puts on 21/06/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

public typealias DownDatabase = Database & DvrDatabase

public protocol Database {
    func transact(block: @escaping () -> Void)
}
