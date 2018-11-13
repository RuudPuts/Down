//
//  RealmDatabase.swift
//  DownKit
//
//  Created by Ruud Puts on 21/06/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import RxSwift
import RealmSwift
import RxRealm

public class RealmDatabase: DownDatabase {
    var realm: Realm!
    
    public init(realm: Realm? = nil) {
        if let realm = realm {
            self.realm = realm
        }
        else {
            self.realm = try! Realm()
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
    
    public func fetchShows() -> Observable<[DvrShow]> {
        let shows = self.realm.objects(DvrShow.self)

        return Observable.array(from: shows)
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
