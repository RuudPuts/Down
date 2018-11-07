//
//  RealmDatabase.swift
//  DownKit
//
//  Created by Ruud Puts on 21/06/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import RealmSwift
import RxSwift

public class RealmDatabase: DownDatabase {
    var realm: Realm!
    
    public init(realm: Realm? = nil) {
        if let realm = realm {
            self.realm = realm
        }
        else {
            createRealm()
        }
    }
    
    public func transact(block: @escaping () -> Void) {
        DispatchQueue.main.async {
            block()
        }
    }
    
    public func store(show: DvrShow) {
        transact {
            // swiftlint:disable force_try
            try! self.realm.write {
                self.realm.add(show, update: true)
            }
        }
    }

    public func delete(show: DvrShow) {
        transact {
            // swiftlint:disable force_try
            try! self.realm.write {
                self.realm.delete(show)
            }
        }
    }
    
    private var fetchShowsToken: NotificationToken?
    public func fetchShows() -> Observable<[DvrShow]> {
        return Observable.create { observer in
            self.transact {
                let shows = self.realm.objects(DvrShow.self)
                self.fetchShowsToken = shows.observe({ changes in
                    switch changes {
                    case .update(let updatedShows, _, _, _):
                        observer.onNext(Array(updatedShows))
                    default: break
                    }
                })
                
                observer.onNext(Array(shows))
            }
            return Disposables.create()
        }
    }
    
    public func fetchShow(matching nameComponents: [String]) -> Maybe<DvrShow> {
        return Maybe.create { observer in
            self.transact {
                var matches: Results<DvrShow>?
                
                for component in nameComponents {
                    let componentFilter = "name contains[c] '\(component)'"
                    
                    var componentMatches = matches
                    if componentMatches == nil {
                        componentMatches = self.realm.objects(DvrShow.self)
                            .filter(componentFilter)
                    }
                    else {
                        componentMatches = matches?.filter(componentFilter)
                    }
                    
                    if componentMatches?.count ?? 0 > 0 {
                        matches = componentMatches
                    }
                    else if matches != nil {
                        break
                    }
                }
                
                if let show = matches?.first {
                    observer(.success(show))
                }
                else {
                    observer(.completed)
                }
            }
            return Disposables.create()
        }
    }
}

extension RealmDatabase {
    func createRealm() {
        transact {
            // swiftlint:disable force_try
            self.realm = try! Realm()
        }
    }
}
