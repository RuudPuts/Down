//
//  DataExtensions.swift
//  DownKitTests
//
//  Created by Ruud Puts on 30/11/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import Foundation

extension Data {
    init(fromFile filename: String, extension: String = "json") {
        let filePath = Bundle.allBundles
            .first(where: { $0.bundlePath.hasSuffix("DownKitTests.xctest") })!
            .path(forResource: filename, ofType: `extension`)!

        // swiftlint:disable force_try
        try! self.init(contentsOf: URL(fileURLWithPath: filePath))
    }
}
