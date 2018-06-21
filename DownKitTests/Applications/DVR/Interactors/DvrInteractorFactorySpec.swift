//
//  DvrInteractorFactorySpec.swift
//  DownKitTests
//
//  Created by Ruud Puts on 16/06/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

@testable import DownKit
import Quick
import Nimble

@testable import DownKit
import Quick
import Nimble

class DvrInteractorFactorySpec: QuickSpec {
    override func spec() {
        describe("DvrInteractorFactory") {
            var sut: DvrInteractorFactory!
            var application: DvrApplication!
            var database: DvrDatabaseMock!
            
            beforeEach {
                database = DvrDatabaseMock()
                sut = DvrInteractorFactory(database: database)
                application = DvrApplication(type: .sickbeard, host: "host", apiKey: "apikey")
            }
            
            afterEach {
                application = nil
                database = nil
                sut = nil
            }
            
            context("show list interactor") {
                var interactor: ShowListInteractor!
                
                beforeEach {
                    interactor = sut.makeShowListInteractor(for: application)
                }
                
                afterEach {
                    application = nil
                }
                
                it("sets the gateway") {
                    expect(interactor.gateway).toNot(beNil())
                }
            }
            
            context("show details interactor") {
                var interactor: ShowDetailsInteractor!
                var show: DvrShow!
                
                beforeEach {
                    show = DvrShow(identifier: "1", name: "show", quality: "quality")
                    interactor = sut.makeShowDetailsInteractor(for: application, show: show)
                }
                
                afterEach {
                    show = nil
                    application = nil
                }
                
                it("sets the show on the gateway") {
                    expect(interactor.gateway.show) === show
                }
            }
        }
    }
}
