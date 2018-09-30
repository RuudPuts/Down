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
            var database: DvrDatabaseMock!

            beforeEach {
                application = DownloadApplication(type: .sabnzbd, host: "host", apiKey: "key")
                builder = DownloadRequestBuildingMock(application: application)
                parser = DownloadResponseParsingMock()
                executor = RequestExecutingMock()
                database = DvrDatabaseMock()

                gateway = DownloadQueueGateway(builder: builder,
                                               parser: parser,
                                               executor: executor)
                sut = DownloadQueueInteractor(gateway: gateway, database: database)
            }

            afterEach {
                sut = nil
                gateway = nil

                database = nil
                executor = nil
                parser = nil
                builder = nil
                application = nil
            }

            context("executing the gateway") {
                var item: DownloadItem!

                beforeEach {
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
                    expect(database.captures.fetchShowsMatching?.nameComponents) == ["test", "item"]
                }
            }
        }
    }
}
