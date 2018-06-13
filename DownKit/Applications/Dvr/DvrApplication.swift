//
//  DvrApplication.swift
//  Down
//
//  Created by Ruud Puts on 04/01/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

public protocol DvrApplication: ApiApplication {
    var dvrResponseParser: DvrResponseParser { get }
    var dvrRequestBuilder: DvrRequestBuilding { get }
}

public enum DvrApplicationCall: ApiCall {
    case showList
    case showDetails(DvrShow)
}
