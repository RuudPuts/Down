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
            var realm: Realm!
            
            beforeEach {
                // swiftlint:disable force_try
                realm = try! Realm(configuration: Realm.Configuration(inMemoryIdentifier: "RealmDatabaseSpec"))
                
                sut = RealmDatabase(realm: realm)
            }
            
            afterEach {
                realm = nil
                sut = nil
            }
            
            context("init without realm") {
                beforeEach {
                    sut = RealmDatabase()
                }
                
                it("creates the Realm") {
                    expect(sut.realm).toEventually(beAKindOf(Realm.self))
                }
            }
            
            context("database") {
                context("transacting") {
                    var thread: Thread!
                    
                    beforeEach {
                        DispatchQueue.global().async {
                            sut.transact {
                                thread = Thread.current
                            }
                        }
                    }
                    
                    afterEach {
                        thread = nil
                    }
                    
                    it("transacts on the main thread") {
                        expect(thread).toEventually(equal(Thread.main))
                    }
                }
            }
            
            context("dvr database") {
                var storedShows: Results<DvrShow>!
                
                afterEach {
                    storedShows = nil
                }
                
                context("storing show") {
                    var show: DvrShow!
                    
                    beforeEach {
                        show = DvrShow(identifier: "1234", name: "TestShow", quality: "Awesome")
                        sut.store(show: show)
                        storedShows = realm.objects(DvrShow.self)
                    }
                    
                    afterEach {
                        show = nil
                    }
                    
                    it("stored 1 show") {
                        expect(storedShows.count).toEventually(equal(1))
                    }
                    
                    it("stored the show") {
                        expect(storedShows.first?.identifier).toEventually(equal(show.identifier))
                    }
                }
            }
        }
    }
}
