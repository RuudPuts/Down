//
//  SickbeardRequestBuilderSpec.swift
//  DownKitTests
//
//  Created by Ruud Puts on 14/06/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

@testable import DownKit
import Quick
import Nimble

class SickbeardRequestBuilderSpec: QuickSpec {
    // swiftlint:disable:next function_body_length
    override func spec() {
        describe("SickbeardRequestBuilder") {
            var sut: SickbeardRequestBuilder!
            var result: RequestSpecification?

            var application: DvrApplication!
            var expectedParamters: [String: String]!

            beforeEach {
                application = DvrApplication(type: .sickbeard, host: "host", apiKey: "key")
                expectedParamters = ["apikey": application.apiKey]

                sut = SickbeardRequestBuilder(application: application)
            }

            afterEach {
                result = nil
                sut = nil
                expectedParamters = nil
                application = nil
            }

            context("dvr request builder") {
                context("build show list call") {
                    beforeEach {
                        result = sut.specification(for: .showList)
                    }

                    it("builds the specification") {
                        expect(result) == RequestSpecification(host: application.host,
                                                               path: "api/{apikey}?cmd=shows",
                                                               parameters: expectedParamters)
                    }
                }

                context("build show details call") {
                    var show: DvrShow!

                    beforeEach {
                        show = DvrShow(identifier: "0", name: "TestShow")
                        expectedParamters.merge(["id": show.identifier], uniquingKeysWith: { $1 })

                        result = sut.specification(for: .showDetails(show))
                    }

                    afterEach {
                        show = nil
                    }

                    it("builds the specification") {
                        expect(result) == RequestSpecification(host: application.host,
                                                               path: "api/{apikey}?cmd=show.seasons%7Cshow&tvdbid={id}",
                                                               parameters: expectedParamters)
                    }
                }

                context("build add show call") {
                    var show: DvrShow!
                    var status: DvrEpisodeStatus!

                    beforeEach {
                        show = DvrShow(identifier: "128", name: "TestShow")
                        status = .wanted

                        expectedParamters.merge([
                                "id": show.identifier,
                                "status": status.sickbeardValue
                            ], uniquingKeysWith: { $1 })

                        result = sut.specification(for: .addShow(show, status))
                    }

                    afterEach {
                        status = nil
                        show = nil
                    }

                    it("builds the specification") {
                        expect(result) == RequestSpecification(host: application.host,
                                                               path: "api/{apikey}?cmd=show.addnew&tvdbid={id}&status={status}",
                                                               parameters: expectedParamters)
                    }
                }

                context("setting episode status") {
                    var show: DvrShow!
                    var season: DvrSeason!
                    var episode: DvrEpisode!
                    var status: DvrEpisodeStatus!

                    beforeEach {
                        show = DvrShow(identifier: "128", name: "TestShow")
                        episode = DvrEpisode(identifier: "1", name: "Episode", airdate: nil)
                        season = DvrSeason(identifier: "1", episodes: [episode], show: show)
                        show.setSeasons([season])

                        status = .wanted

                        expectedParamters.merge([
                                "show_id": show.identifier,
                                "season_id": season.identifier,
                                "episode_id": episode.identifier,
                                "status": status.sickbeardValue
                            ], uniquingKeysWith: { $1 })

                        result = sut.specification(for: .setEpisodeStatus(episode, status))
                    }

                    afterEach {
                        status = nil
                        show = nil
                        season = nil
                        episode = nil
                    }

                    it("builds the specification") {
                        expect(result) == RequestSpecification(host: application.host,
                                                               path: "api/{apikey}?cmd=episode.setstatus&tvdbid={show_id}&season={season_id}&episode={episode_id}&status={status}",
                                                               parameters: expectedParamters)
                    }
                }

                context("setting season status") {
                    var show: DvrShow!
                    var season: DvrSeason!
                    var status: DvrEpisodeStatus!

                    beforeEach {
                        show = DvrShow(identifier: "128", name: "TestShow")
                        season = DvrSeason(identifier: "1", episodes: [], show: show)
                        show.setSeasons([season])

                        status = .wanted

                        expectedParamters.merge([
                            "show_id": show.identifier,
                            "season_id": season.identifier,
                            "status": status.sickbeardValue
                            ], uniquingKeysWith: { $1 })

                        result = sut.specification(for: .setSeasonStatus(season, status))
                    }

                    afterEach {
                        status = nil
                        show = nil
                        season = nil
                    }

                    it("builds the specification") {
                        expect(result) == RequestSpecification(host: application.host,
                                                               path: "api/{apikey}?cmd=episode.setstatus&tvdbid={show_id}&season={season_id}&status={status}",
                                                               parameters: expectedParamters)
                    }
                }

                context("fetching episode details") {
                    var show: DvrShow!
                    var season: DvrSeason!
                    var episode: DvrEpisode!

                    beforeEach {
                        show = DvrShow(identifier: "128", name: "TestShow")
                        episode = DvrEpisode(identifier: "1", name: "Episode", airdate: nil)
                        season = DvrSeason(identifier: "1", episodes: [episode], show: show)
                        show.setSeasons([season])

                        expectedParamters.merge([
                            "show_id": show.identifier,
                            "season_id": season.identifier,
                            "episode_id": episode.identifier
                            ], uniquingKeysWith: { $1 })

                        result = sut.specification(for: .fetchEpisodeDetails(episode))
                    }

                    afterEach {
                        show = nil
                        season = nil
                        episode = nil
                    }

                    it("builds the specification") {
                        expect(result) == RequestSpecification(host: application.host,
                                                               path: "api/{apikey}?cmd=episode&tvdbid={show_id}&season={season_id}&episode={episode_id}",
                                                               parameters: expectedParamters)
                    }
                }
            }

            context("api application request builder") {
                context("build login call") {
                    var credentials: UsernamePassword!

                    beforeEach {
                        credentials = ("username", "password")
                        result = sut.specification(for: .login, credentials: credentials)
                    }

                    afterEach {
                        credentials = nil
                    }

                    it("builds the specification") {
                        expect(result) == RequestSpecification(host: application.host,
                                                               authenticationMethod: .basic,
                                                               basicAuthenticationData: credentials)
                    }
                }

                context("build api key call") {
                    beforeEach {
                        result = sut.specification(for: .apiKey)
                    }

                    it("builds the specification") {
                        expect(result) == RequestSpecification(host: application.host,
                                                               path: "config/general")
                    }
                }
            }
        }
    }
}
