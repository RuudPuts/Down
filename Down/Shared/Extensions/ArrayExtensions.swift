//
//  ArrayExtensions.swift
//  Down
//
//  Created by Ruud Puts on 02/01/2019.
//  Copyright © 2019 Mobile Sorcery. All rights reserved.
//

import Foundation

extension Array where Element: Hashable {
    func unique() -> [Element] {
        return Array(Set(self))
    }
}
