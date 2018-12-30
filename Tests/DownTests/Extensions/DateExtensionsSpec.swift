//
//  DateExtensionsSpec.swift
//  DownKitTests
//
//  Created by Ruud Puts on 13/06/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

@testable import Down
import Quick
import Nimble

class DateExtensionsSpec: QuickSpec {
    override func spec() {
        describe("Date") {
            var sut: Date!

            context("time string from seconds since reference date") {
                var result: String!

                afterEach {
                    sut = nil
                }

                context("less then an hour") {
                    beforeEach {
                        sut = Date(timeIntervalSinceReferenceDate: 315)
                        result = sut.timeString
                    }

                    it("returns minute second numeric string") {
                        expect(result) == "05:15"
                    }
                }

                context("more than an hour") {
                    beforeEach {
                        sut = Date(timeIntervalSinceReferenceDate: 4505)
                        result = sut.timeString
                    }

                    it("returns hour minute second numeric string") {
                        expect(result) == "01:15:05"
                    }
                }
            }
        }
    }
}
