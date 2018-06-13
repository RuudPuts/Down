//
//  DvrRequestGateway.swift
//  Down
//
//  Created by Ruud Puts on 03/06/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

protocol DvrRequestGateway: RequestGateway {
    var dvrRequestBuilder: DvrRequestBuilding { get }
}

extension DvrRequestGateway {
    var dvrRequestBuilder: DvrRequestBuilding {
        // swiftlint:disable force_cast
        return requestBuilder as! DvrRequestBuilding
    }
}
