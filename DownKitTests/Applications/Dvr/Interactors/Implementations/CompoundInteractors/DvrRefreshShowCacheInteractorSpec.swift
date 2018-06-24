//
//  DvrRefreshShowCacheInteractorSpec.swift
//  DownKitTests
//
//  Created by Ruud Puts on 16/06/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

@testable import DownKit
import RxSwift
import Quick
import Nimble

class DvrRefreshShowCacheInteractorSpec: QuickSpec {
    override func spec() {
        describe("DvrRefreshShowCacheInteractor") {
            var sut: DvrRefreshShowCacheInteractor!
            var database: DvrDatabaseMock!
            
            var showListGateway: DvrShowListGateway!
            var showListInteractor: DvrShowListInteractor!
            
            var showDetailsGateway: DvrShowDetailsGateway!
            var showDetailsInteractor: DvrShowDetailsInteractor!
            
            var application: DvrApplication!
            var builder: DvrRequestBuildingMock!
            var parser: DvrResponseParsingMock!
            var executor: RequestExecutingMock!
            
            beforeEach {
                database = DvrDatabaseMock()
                application = DvrApplication(type: .sickbeard, host: "host", apiKey: "key")
                builder = DvrRequestBuildingMock(application: application)
                parser = DvrResponseParsingMock()
                executor = RequestExecutingMock()
                
                showListGateway = DvrShowListGateway(builder: builder, parser: parser, executor: executor)
                showListInteractor = DvrShowListInteractor(gateway: showListGateway)
                
                showDetailsGateway = DvrShowDetailsGateway(builder: builder, parser: parser, executor: executor)
                showDetailsInteractor = DvrShowDetailsInteractor(gateway: showDetailsGateway)
                
                let interactors = (showList: showListInteractor!, showDetails: showDetailsInteractor!)
                sut = DvrRefreshShowCacheInteractor(interactors: interactors, database: database)
            }
            
            afterEach {
                sut = nil
                
                showListInteractor = nil
                showListGateway = nil
                
                showDetailsInteractor = nil
                showDetailsGateway = nil
                
                application = nil
                builder = nil
                parser = nil
                executor = nil
            }
            
            context("observing") {
                beforeEach {
//                    _ = sut.observe()
                }
                
                it("") {
                    // Not sure how to stub this without stubbing the whole gateway chain
                    // ie. I could use the Sickbeard parser, builder and only stub the executor
                    // Still though..
                    
                    // DvrShowDetailsInteractor can't be made generic, as RequestGatewayInteractor has a Self requirement
                    
                    // Can be tested with integration tests though
                }
            }
        }
    }
}
