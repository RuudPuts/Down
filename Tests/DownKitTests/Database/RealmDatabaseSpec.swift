//
//  RealmDatabaseSpec.swift
//  DownKitTests
//
//  Created by Ruud Puts on 21/06/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

@testable import DownKit
import RealmSwift
import RxSwift
import RxBlocking
import RxNimble
import Quick
import Nimble

class RealmDatabaseSpec: QuickSpec {
    // swiftlint:disable function_body_length
    override func spec() {
        describe("RealmDatabase") {
            var sut: RealmDatabase!
            var configuration: Realm.Configuration!
            
            beforeEach {
                configuration = Realm.Configuration(inMemoryIdentifier: "RealmSpec-\(UUID().uuidString)")

                sut = RealmDatabase(configuration: configuration)
            }
            
            afterEach {
                sut = nil
                configuration = nil
            }

            context("dvr database") {
                var storedShows: Observable<[DvrShow]>!
                
                afterEach {
                    storedShows = nil
                }
                
                describe("storing shows") {
                    var show: DvrShow!
                    
                    beforeEach {
                        show = DvrShow(identifier: "1234", name: "TestShow")
                        sut.store(shows: [show])
                        storedShows = sut.fetchShows()
                    }
                    
                    afterEach {
                        show = nil
                    }
                    
                    it("stored 1 show") {
                        expect(storedShows.map { $0.count }).first == 1
                    }
                    
                    it("stored the show") {
                        expect(storedShows.map { $0.first?.identifier ?? "" }).first == show.identifier
                    }
                }

                describe("fetching episodes") {
                    var result: Observable<[DvrEpisode]>!
                    var allShows: [DvrShow]!

                    beforeEach {
                        allShows = self.makeShowsAiringDifferentDates()
                        sut.store(shows: allShows)
                    }

                    afterEach {
                        result = nil
                    }

                    describe("airing on specific date") {
                        context("date without matches") {
                            beforeEach {
                                result = sut.fetchEpisodes(airingOn: Date(timeIntervalSinceReferenceDate: 0))
                            }

                            it("fetches no episodes") {
                                expect(result.map { $0.isEmpty }).first == true
                            }
                        }

                        context("date with match") {
                            var date: Date!

                            beforeEach {
                                date = Calendar.makeDate(year: 2010, month: 5, day: 2)
                                result = sut.fetchEpisodes(airingOn: date)
                            }

                            afterEach {
                                date = nil
                            }

                            it("matches one episode") {
                                expect(result.map { $0.count }).first == 1
                            }

                            it("matches the episode") {
                                expect(result).first == [allShows[2].seasons.first!.episodes[2]]
                            }
                        }

                        context("date with multiple matches") {
                            beforeEach {
                                let date = Calendar.makeDate(year: 2010, month: 5, day: 4)
                                result = sut.fetchEpisodes(airingOn: date)
                            }

                            it("matches two episodes") {
                                expect(result.map { $0.count }).first == 2
                            }

                            it("matches the episodes") {
                                expect(result).first == Array(allShows[1].seasons.first!.episodes)
                            }
                        }

                        context("date with time") {
                            beforeEach {
                                let date = Calendar.makeDate(year: 2010, month: 5, day: 4, hour: 16, minute: 19, second: 3)
                                result = sut.fetchEpisodes(airingOn: date)
                            }

                            it("matches two episodes") {
                                expect(result.map { $0.count }).first == 2
                            }

                            it("matches the episodes") {
                                expect(result).first == Array(allShows[1].seasons.first!.episodes[0...1])
                            }
                        }
                    }

                    describe("airing on any day between two dates") {
                        context("dates without matches") {
                            beforeEach {
                                result = sut.fetchEpisodes(airingBetween: Date(timeIntervalSince1970: 0),
                                                           and: Date(timeIntervalSinceReferenceDate: 0))
                            }

                            it("fetches no episodes") {
                                expect(result.map { $0.isEmpty }).first == true
                            }
                        }

                        context("dates with matches") {
                            beforeEach {
                                result = sut.fetchEpisodes(airingBetween: Calendar.makeDate(year: 2010, month: 5, day: 4),
                                                           and: Calendar.makeDate(year: 2010, month: 6, day: 1))
                            }

                            it("matches three episodes") {
                                expect(result.map { $0.count }).first == 3
                            }

                            it("matches the episodes") {
                                expect(result).first == [
                                    allShows[1].seasons.first!.episodes[0],
                                    allShows[1].seasons.first!.episodes[1],
                                    allShows[0].seasons.first!.episodes[1]
                                ]
                            }
                        }

                        context("same from and to date") {
                            beforeEach {
                                result = sut.fetchEpisodes(airingBetween: Calendar.makeDate(year: 2010, month: 5, day: 2),
                                                           and: Calendar.makeDate(year: 2010, month: 5, day: 2))
                            }

                            it("matches one episode") {
                                expect(result.map { $0.count }).first == 1
                            }

                            it("matches the episode") {
                                expect(result).first == [allShows[2].seasons.first!.episodes[2]]
                            }
                        }

                        context("dates with times") {
                            beforeEach {
                                let fromDate = Calendar.makeDate(year: 2010, month: 5, day: 4, hour: 16, minute: 19, second: 3)
                                let toDate = Calendar.makeDate(year: 2010, month: 6, day: 1, hour: 16, minute: 19, second: 3)
                                result = sut.fetchEpisodes(airingBetween: fromDate, and: toDate)
                            }

                            it("matches three episodes") {
                                expect(result.map { $0.count }).first == 3
                            }

                            it("matches the episodes") {
                                expect(result).first == [
                                    allShows[1].seasons.first!.episodes[0],
                                    allShows[1].seasons.first!.episodes[1],
                                    allShows[0].seasons.first!.episodes[1]
                                ]
                            }
                        }
                    }
                }
            }
        }
    }
    // swiftlint:enable function_body_length

    func makeShowsAiringDifferentDates() -> [DvrShow] {
        return [
            makeShow(identifier: "3", episodesAiring: [
                Calendar.makeDate(year: 2010, month: 6, day: 2),
                Calendar.makeDate(year: 2010, month: 6, day: 1)
            ]),
            makeShow(identifier: "1", episodesAiring: [
                Calendar.makeDate(year: 2010, month: 5, day: 4),
                Calendar.makeDate(year: 2010, month: 5, day: 4)
            ]),
            makeShow(identifier: "2", episodesAiring: [
                Calendar.makeDate(year: 2010, month: 5, day: 3),
                Calendar.makeDate(year: 2010, month: 5, day: 1),
                Calendar.makeDate(year: 2010, month: 5, day: 2)
            ])
        ]
    }

    func makeShow(identifier: String, episodesAiring: [Date]) -> DvrShow {
        var count = 0
        let episodes = episodesAiring.map { date -> DvrEpisode in
            count += 1
            return DvrEpisode(identifier: "\(count)", name: "episode", airdate: date)
        }

        let show = DvrShow(identifier: identifier, name: "show" + identifier)
        show.setSeasons([
            DvrSeason(identifier: "1", episodes: episodes, show: show)
        ])

        return show
    }
}

private extension Calendar {
    static func makeDate(year: Int, month: Int, day: Int, hour: Int = 0, minute: Int = 0, second: Int = 0) -> Date {
        let components = DateComponents(year: year, month: month, day: day,
                                        hour: hour, minute: minute, second: second)

        return Calendar.current.date(from: components)!
    }
}
