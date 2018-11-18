//
//  RequestStub.swift
//  DownKitTests
//
//  Created by Ruud Puts on 09/11/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import Foundation
@testable import DownKit

extension Request {
    static var defaultStub: Request {
        return Request(url: URL.defaultStub, method: .get)
    }
}
