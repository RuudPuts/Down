//
//  DvrApplication.swift
//  Down
//
//  Created by Ruud Puts on 04/01/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

protocol DvrApplication: ApiApplication {
    var dvrRequestBuilder: DvrRequestBuilding { get }
    var dvrResponseParser: DvrResponseParser { get }
}

enum DvrApplicationCall: ApiCall {
    case showList
    case showDetails(DvrShow)
}
