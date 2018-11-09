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
            var dependenciesStub: DownKitDependenciesStub!
            
            beforeEach {
                dependenciesStub = DownKitDependenciesStub()
                sut = DownloadInteractorFactory(dependencies: dependenciesStub)
                application = DownloadApplication(type: .sabnzbd, host: "host", apiKey: "apikey")
            }
            
            afterEach {
                application = nil
                dependenciesStub = nil
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
            }
        }
    }
}
