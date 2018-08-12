//
//  DownloadInteractorFactorySpec.swift
//  DownKitTests
//
//  Created by Ruud Puts on 16/06/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

@testable import DownKit
import Quick
import Nimble

class DownloadInteractorFactorySpec: QuickSpec {
    override func spec() {
        describe("DownloadInteractorFactory") {
            var sut: DownloadInteractorFactory!
            var application: DownloadApplication!
            var database: DvrDatabaseMock!
            
            beforeEach {
                database = DvrDatabaseMock()
                sut = DownloadInteractorFactory(dvrDatabase: database)
                application = DownloadApplication(type: .sabnzbd, host: "host", apiKey: "apikey")
            }
            
            afterEach {
                application = nil
                database = nil
                sut = nil
            }
            
            context("queue interactor") {
                var interactor: DownloadQueueInteractor!
                
                beforeEach {
                    interactor = sut.makeQueueInteractor(for: application)
                }
                
                afterEach {
                    interactor = nil
                }
                
                it("sets the queue gateway") {
                    expect(interactor.gateway).to(beAnInstanceOf(DownloadQueueGateway.self))
                }

                it("sets the database") {
                    expect(interactor.database) === database
                }
            }
            
            context("history interactor") {
                var interactor: DownloadHistoryInteractor!
                
                beforeEach {
                    interactor = sut.makeHistoryInteractor(for: application)
                }
                
                afterEach {
                    interactor = nil
                }

                it("sets the history gateway") {
                    expect(interactor.gateway).to(beAnInstanceOf(DownloadHistoryGateway.self))
                }
                
                it("sets the database") {
                    expect(interactor.database) === database
                }
            }
        }
    }
}
