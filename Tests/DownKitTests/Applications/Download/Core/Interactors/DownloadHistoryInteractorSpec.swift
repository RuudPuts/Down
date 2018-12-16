//
//  DownloadHistoryInteractorSpec.swift
//  DownKitTests
//
//  Created by Ruud Puts on 01/08/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

@testable import DownKit
import RxSwift
import Quick
import Nimble

class DownloadHistoryInteractorSpec: QuickSpec {
    // swiftlint:disable function_body_length
    override func spec() {
        describe("DownloadHistoryInteractor") {
            var sut: DownloadHistoryInteractor!
            var gateway: DownloadHistoryGateway!

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

                gateway = DownloadHistoryGateway(builder: builder,
                                                 parser: parser,
                                                 executor: executor)
                sut = DownloadHistoryInteractor(dependencies: dependenciesStub, gateway: gateway)
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
                    parser.stubs.parseHistory = [item]

                    _ = sut
                        .observe()
                        .toBlocking()
                        .materialize()
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
    // swiftlint:enable function_body_length
}
