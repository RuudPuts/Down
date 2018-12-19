//
//  DvrRefreshShowCacheInteractorSpec.swift
//  DownKitTests
//
//  Created by Ruud Puts on 16/06/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

@testable import DownKit
import RxSwift
import RealmSwift
import Quick
import Nimble
import RxNimble

class DvrRefreshShowCacheInteractorSpec: QuickSpec {
    // swiftlint:disable:next function_body_length
    override func spec() {
        describe("DvrRefreshShowCacheInteractor") {
            var sut: DvrRefreshShowCacheInteractor!

            var application: DvrApplication!
            var database: DownDatabaseMock!
            var interactorFactory: DvrInteractorProducingMock!

            var fetchedShows: [DvrShow]!
            
            beforeEach {
                application = DvrApplication(type: .sickbeard, host: "host", apiKey: "key")
                database = DownDatabaseMock()

                interactorFactory = DvrInteractorProducingMock()
                interactorFactory.stubs.database = database

                sut = DvrRefreshShowCacheInteractor(application: application,
                                                    interactors: interactorFactory,
                                                    database: database)
            }
            
            afterEach {
                sut = nil

                interactorFactory = nil
                database = nil
                application = nil

                fetchedShows = nil
            }

            describe("updating the cache") {
                var storedShows: [DvrShow]!
                var result: Observable<[DvrShow]>!

                afterEach {
                    result = nil
                    storedShows = nil
                }

                describe("processing deleted shows") {
                    var deletedShow: DvrShow!

                    beforeEach {
                        fetchedShows = [
                            DvrShow(identifier: "1", name: "Show1"),
                            DvrShow(identifier: "2", name: "Show2")
                        ]

                        deletedShow = DvrShow(identifier: "3", name: "Show3")
                        storedShows = [
                            DvrShow(identifier: "1", name: "Show1"),
                            DvrShow(identifier: "2", name: "Show2"),
                            deletedShow
                        ]
                        database.stubs.fetchShows = storedShows

                        result = sut.processDeletedShows(fetchedShows)
                    }

                    afterEach {
                        deletedShow = nil
                    }

                    it("deletes the last stored show") {
                        _ = try? result.toBlocking().first()

                        expect(database.captures.deleteShow?.show) == storedShows.last
                    }

                    it("returns fetched shows") {
                        expect(result).first == fetchedShows
                    }
                }

                describe("determining shows to refresh") {
                    context("newly added show") {
                        var newShow: DvrShow!

                        beforeEach {
                            newShow = DvrShow(identifier: "4", name: "Show4")
                            fetchedShows = [
                                DvrShow(identifier: "1", name: "Show1"),
                                DvrShow(identifier: "2", name: "Show2"),
                                newShow
                            ]

                            storedShows = [
                                DvrShow(identifier: "1", name: "Show1"),
                                DvrShow(identifier: "2", name: "Show2")
                            ]
                            database.stubs.fetchShows = storedShows

                            result = sut.determineShowsToRefresh(fetchedShows)
                        }

                        afterEach {
                            newShow = nil
                        }

                        it("returns the new show to refresh") {
                            expect(result).first == [newShow]
                        }
                    }

                    context("show with newly aired episode") {
                        context("episode aired one hour ago") {
                            var showToUpdate: DvrShow!

                            beforeEach {
                                showToUpdate = self.makeShow(withEpisodeAiringOn: Date().addingTimeInterval(-3600))

                                fetchedShows = [
                                    DvrShow(identifier: "1", name: "Show1"),
                                    DvrShow(identifier: "2", name: "Show2")
                                ]

                                storedShows = [
                                    showToUpdate,
                                    DvrShow(identifier: "2", name: "Show2")
                                ]
                                database.stubs.fetchShows = storedShows

                                result = sut.determineShowsToRefresh(fetchedShows)
                            }

                            afterEach {
                                showToUpdate = nil
                            }

                            it("returns the show to refresh") {
                                expect(result).first == [showToUpdate]
                            }
                        }

                        context("episode aired one week and one hour ago") {
                            var showToUpdate: DvrShow!

                            beforeEach {
                                showToUpdate = self.makeShow(withEpisodeAiringOn: Date().addingTimeInterval(-608400))

                                fetchedShows = [
                                    DvrShow(identifier: "1", name: "Show1"),
                                    DvrShow(identifier: "2", name: "Show2")
                                ]

                                storedShows = [
                                    showToUpdate,
                                    DvrShow(identifier: "2", name: "Show2")
                                ]
                                database.stubs.fetchShows = storedShows

                                result = sut.determineShowsToRefresh(fetchedShows)
                            }

                            afterEach {
                                showToUpdate = nil
                            }

                            it("returns no shows to refresh") {
                                expect(result).first == []
                            }
                        }

                        context("episode airing in one hour") {
                            var showToUpdate: DvrShow!

                            beforeEach {
                                showToUpdate = self.makeShow(withEpisodeAiringOn: Date().addingTimeInterval(3600))

                                fetchedShows = [
                                    DvrShow(identifier: "1", name: "Show1"),
                                    DvrShow(identifier: "2", name: "Show2")
                                ]

                                storedShows = [
                                    showToUpdate,
                                    DvrShow(identifier: "2", name: "Show2")
                                ]
                                database.stubs.fetchShows = storedShows

                                result = sut.determineShowsToRefresh(fetchedShows)
                            }

                            afterEach {
                                showToUpdate = nil
                            }

                            it("returns no shows to refresh") {
                                expect(result).first == []
                            }
                        }
                    }
                }
            }

            describe("refreshing show details") {

            }
        }
    }

    func makeShow(withEpisodeAiringOn airDate: Date) -> DvrShow {
        let show = DvrShow(identifier: "1", name: "Show1")

        let seasons = List<DvrSeason>()
        seasons.append(
            DvrSeason(identifier: "1",
                      episodes: [
                          DvrEpisode(identifier: "1",
                                     name: "Episode 1",
                                     airdate: airDate)
                      ],
                      show: show)
        )
        show.seasons = seasons

        return show
    }
}
