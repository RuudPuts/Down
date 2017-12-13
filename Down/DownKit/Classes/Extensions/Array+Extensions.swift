//
//  Array+Extensions.swift
//  DownKit
//
//  Created by Ruud Puts on 12/12/2017.
//  Copyright © 2017 Ruud Puts. All rights reserved.
//

import Foundation

extension Array {
    func test() {
        
    }
}

extension Array where Element: Hashable {
    func subtracting(_ array: [Element]) -> [Element] {
        return Array(Set(self).subtracting(Set(array)))
    }
}
