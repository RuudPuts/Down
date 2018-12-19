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
    // swiftlint:disable:next function_body_length
    override func spec() {
        describe("Date") {
            var sut: Date!

            context("date string") {
                var result: String!

                beforeEach {
                    let components = DateComponents(year: 2010, month: 5, day: 15,
                                                    hour: 0, minute: 0, second: 0)
                    sut = Calendar.current.date(from: components)
                    result = sut.dateString
                }

                afterEach {
                    sut = nil
                }

                it("returns year month day numeric string") {
                    expect(result) == "2010-05-15"
                }
            }

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

            context("date time string") {
                var result: String!

                beforeEach {
                    let components = DateComponents(year: 2010, month: 5, day: 15,
                                                    hour: 14, minute: 5, second: 2)
                    sut = Calendar.current.date(from: components)
                    result = sut.dateTimeString
                }

                afterEach {
                    sut = nil
                }

                it("returns moth day hour minute alpha numeric string") {
                    expect(result) == "15 May 14:05"
                }
            }
        }
    }
}
