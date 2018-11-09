//
//  DownloadQueueInteractorSpec.swift
//  DownKitTests
//
//  Created by Ruud Puts on 12/08/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

@testable import DownKit
import RxSwift
import Quick
import Nimble

class DownloadQueueInteractorSpec: QuickSpec {
    override func spec() {
        describe("DownloadQueueInteractor") {
            var sut: DownloadQueueInteractor!
            var gateway: DownloadQueueGateway!

            var application: DownloadApplication!
            var builder: DownloadRequestBuildingMock!
            var parser: DownloadResponseParsingMock!
            var executor: RequestExecutingMock!
            var dependenciesStub: DownKitDependenciesStub!

            beforeEach {
                application = DownloadApplication(type: .sabnzbd, host: "host", apiKey: "key")
                builder = DownloadRequestBuildingMock(application: application)
                parser = DownloadResponseParsingMock()
                executor = RequestExecutingMock()
                dependenciesStub = DownKitDependenciesStub()

                gateway = DownloadQueueGateway(builder: builder,
                                               parser: parser,
                                               executor: executor)
                sut = DownloadQueueInteractor(dependencies: dependenciesStub, gateway: gateway)
            }

            afterEach {
                sut = nil
                gateway = nil

                dependenciesStub = nil
                executor = nil
                parser = nil
                builder = nil
                application = nil
            }

            context("executing the gateway") {
                var item: DownloadItem!

                beforeEach {
                    builder.stubs.make = Request.defaultStub
                    item = DownloadItem(identifier: "test_item", name: "test.item.S01E01", category: "", sizeMb: 0, progress: 0)
                    parser.stubs.parseQueue = DownloadQueue(items: [item])

                    do {
                        _ = try sut
                            .observe()
                            .toBlocking()
                            .first()
                    }
                    catch {
                        fail("Failed to execute gateway: \(error.localizedDescription)")
                    }
                }

                afterEach {
                    item = nil
                }

                it("matches the items with the database") {
                    expect(dependenciesStub.databaseMock.captures.fetchShowsMatching?.nameComponents) == ["test", "item"]
                }
            }
        }
    }
}
