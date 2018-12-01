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
import Quick
import Nimble

class RealmDatabaseSpec: QuickSpec {
    // swiftlint:disable function_body_length
    override func spec() {
        describe("RealmDatabase") {
            var sut: RealmDatabase!
            var configuration: Realm.Configuration!
            
            beforeEach {
                configuration = Realm.Configuration(inMemoryIdentifier: "RealmDatabaseSpec")
                
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
                
                context("storing show") {
                    var show: DvrShow!
                    
                    beforeEach {
                        show = DvrShow(identifier: "1234", name: "TestShow")
                        sut.store(show: show)
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
            }
        }
    }
}
