//
//  DataStoringSpec.swift
//  DownKitTests
//
//  Created by Ruud Puts on 18/05/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

@testable import DownKit
import Foundation

class DataStoringMock: DataStoring {
    struct Stubs {
        var data: Data?
    }
    
    struct Captures {
        var data: Data?
    }
    
    var stubs = Stubs()
    var captures = Captures()
    
    // DataStoring
    
    var data: Data? {
        get { return stubs.data }
        set { captures.data = newValue }
    }
}
