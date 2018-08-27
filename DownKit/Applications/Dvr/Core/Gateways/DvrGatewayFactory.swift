//
//  DvrGatewayFactory.swift
//  DownKit
//
//  Created by Ruud Puts on 17/06/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

public protocol DvrGatewayProducing {
    func makeShowListGateway(for application: DvrApplication) -> DvrShowListGateway
    func makeShowDetailsGateway(for application: DvrApplication, show: DvrShow) -> DvrShowDetailsGateway
    func makeSearchShowsGateway(for application: DvrApplication, query: String) -> DvrSearchShowsGateway
    func makeAddShowGateway(for application: DvrApplication, show: DvrShow) -> DvrAddShowGateway
    func makeFetchBannerGateway(for application: DvrApplication, show: DvrShow) -> DvrFetchBannerGateway
    func makeFetchPosterGateway(for application: DvrApplication, show: DvrShow) -> DvrFetchPosterGateway
}

public class DvrGatewayFactory: DvrGatewayProducing {
    var additionsFactory: ApplicationAdditionsProducing
    
    public init(additionsFactory: ApplicationAdditionsProducing = ApplicationAdditionsFactory()) {
        self.additionsFactory = additionsFactory
    }
    
    public func makeShowListGateway(for application: DvrApplication) -> DvrShowListGateway {
        return DvrShowListGateway(builder: additionsFactory.makeDvrRequestBuilder(for: application),
                                  parser: additionsFactory.makeDvrResponseParser(for: application))
    }
    
    public func makeShowDetailsGateway(for application: DvrApplication, show: DvrShow) -> DvrShowDetailsGateway {
        return DvrShowDetailsGateway(show: show,
                                     builder: additionsFactory.makeDvrRequestBuilder(for: application),
                                     parser: additionsFactory.makeDvrResponseParser(for: application))
    }

    public func makeSearchShowsGateway(for application: DvrApplication, query: String) -> DvrSearchShowsGateway {
        return DvrSearchShowsGateway(query: query,
                                     builder: additionsFactory.makeDvrRequestBuilder(for: application),
                                     parser: additionsFactory.makeDvrResponseParser(for: application))
    }

    public func makeAddShowGateway(for application: DvrApplication, show: DvrShow) -> DvrAddShowGateway {
        return DvrAddShowGateway(show: show,
                                 builder: additionsFactory.makeDvrRequestBuilder(for: application),
                                 parser: additionsFactory.makeDvrResponseParser(for: application))
    }

    public func makeFetchBannerGateway(for application: DvrApplication, show: DvrShow) -> DvrFetchBannerGateway {
        return DvrFetchBannerGateway(builder: additionsFactory.makeDvrRequestBuilder(for: application),
                                     parser: additionsFactory.makeDvrResponseParser(for: application))
    }

    public func makeFetchPosterGateway(for application: DvrApplication, show: DvrShow) -> DvrFetchPosterGateway {
        return DvrFetchPosterGateway(builder: additionsFactory.makeDvrRequestBuilder(for: application),
                                     parser: additionsFactory.makeDvrResponseParser(for: application))
    }
}
