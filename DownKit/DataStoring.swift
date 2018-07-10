//
//  DataStoring.swift
//  Down
//
//  Created by Ruud Puts on 13/01/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import Foundation

//! This whole protocol is bullshit.

public protocol DataStoring {
    var data: Data? { get }
}

protocol DataStoringDecoding {
    func decode(storage: DataStoring)
}
