//
//  Down.swift
//  Down
//
//  Created by Ruud Puts on 03/06/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import DownKit
import UIKit

class RXRequest {
    static var dvrApplication: DvrApplication {
        return SickbeardApplication(host: "http://192.168.2.100:8081",
                                   apiKey: "e9c3be0f3315f09d7ceae37f1d3836cd")
    }
}
