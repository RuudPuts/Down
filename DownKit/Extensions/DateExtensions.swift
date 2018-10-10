//
//  DateExtensions.swift
//  DownKit
//
//  Created by Ruud Puts on 09/10/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import Foundation

extension Date {
    func isBetweeen(date lhs: Date, and rhs: Date) -> Bool {
        return lhs.compare(self) == self.compare(rhs)
    }
}
