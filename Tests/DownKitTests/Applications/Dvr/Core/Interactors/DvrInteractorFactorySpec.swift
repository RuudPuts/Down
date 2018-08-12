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
    // swiftlint:disable function_body_length
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
                var interactor: DvrShowListInteractor!
                
                beforeEach {
                    interactor = sut.makeShowListInteractor(for: application)
                }
                
                afterEach {
                    interactor = nil
                }
                
                it("sets the show list gateway") {
                    expect(interactor.gateway).to(beAnInstanceOf(DvrShowListGateway.self))
                }
            }
            
            context("show details interactor") {
                var interactor: DvrShowDetailsInteractor!
                var show: DvrShow!
                
                beforeEach {
                    show = DvrShow(identifier: "1", name: "show")
                    interactor = sut.makeShowDetailsInteractor(for: application, show: show)
                }
                
                afterEach {
                    show = nil
                    interactor = nil
                }

                it("sets the show details gateway") {
                    expect(interactor.gateway).to(beAnInstanceOf(DvrShowDetailsGateway.self))
                }

                it("sets the show on the gateway") {
                    expect(interactor.gateway.show) === show
                }
            }
            
            context("refresh show cache interactor") {
                var interactor: DvrRefreshShowCacheInteractor!
                
                beforeEach {
                    interactor = sut.makeShowCacheRefreshInteractor(for: application)
                }
                
                afterEach {
                    interactor = nil
                }

                it("sets the show list interactor") {
                    expect(interactor.interactors.showList).to(beAKindOf(DvrShowListInteractor.self))
                }
                
                it("sets the show details interactor") {
                    expect(interactor.interactors.showDetails).to(beAKindOf(DvrShowDetailsInteractor.self))
                }
                
                it("sets the database") {
                    expect(interactor.database) === database
                }
            }

            context("search shows interactor") {
                var interactor: DvrSearchShowsInteractor!
                var query: String!

                beforeEach {
                    query = "test query"
                    interactor = sut.makeSearchShowsInteractor(for: application, query: query)
                }

                afterEach {
                    query = nil
                    interactor = nil
                }

                it("sets the search shows gateway") {
                    expect(interactor.gateway).to(beAnInstanceOf(DvrSearchShowsGateway.self))
                }

                it("sets the query on the gateway") {
                    expect(interactor.gateway.query) == query
                }
            }

            context("add show interactor") {
                var interactor: DvrAddShowInteractor!
                var show: DvrShow!

                beforeEach {
                    show = DvrShow(identifier: "1", name: "show")
                    interactor = sut.makeAddShowInteractor(for: application, show: show)
                }

                afterEach {
                    show = nil
                    interactor = nil
                }

                it("sets the add show interactor") {
                    expect(interactor.interactors.addShow).to(beAnInstanceOf(DvrAddShowGateway.self))
                }

                it("sets the show details interactor") {
                    expect(interactor.interactors.showDetails).to(beAnInstanceOf(DvrShowDetailsInteractor.self))
                }

                it("sets the database") {
                    expect(interactor.database) === database
                }
            }
        }
    }
}
