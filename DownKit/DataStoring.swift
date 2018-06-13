//
//  DataStoring.swift
//  Down
//
//  Created by Ruud Puts on 13/01/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import Foundation

protocol DataStoring {
    var data: Data? { get }
}

protocol DataStoringDecoder {
    func decode(storage: DataStoring)
}
