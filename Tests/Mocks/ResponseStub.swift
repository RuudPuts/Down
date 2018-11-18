//
//  ResponseStub.swift
//  Down
//
//  Created by Ruud Puts on 18/11/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import Foundation
@testable import DownKit

extension Response {
    static var defaultStub = Response(data: nil, statusCode: -1, headers: nil)
}
