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
    public init() {}

    public func transact(block: @escaping () -> Void) {
//        DispatchQueue.main.async {
            block()
//        }
    }
    
    public func store(show: DvrShow) {
        transact {
            // swiftlint:disable force_try
            let realm = try! Realm()
            try! realm.write {
                realm.add(show, update: true)
            }
        }
    }

    public func delete(show: DvrShow) {
        transact {
            // swiftlint:disable force_try
            let realm = try! Realm()
            try! realm.write {
                realm.delete(show)
            }
        }
    }
    
    public func fetchShows() -> Observable<[DvrShow]> {
        let realm = try! Realm()

        return Observable.array(from: realm.objects(DvrShow.self))
    }
    
    public func fetchShow(matching nameComponents: [String]) -> Maybe<DvrShow> {
        return Maybe.create { observer in
            self.transact {
                var matches: Results<DvrShow>?

                let realm = try! Realm()
                for component in nameComponents {
                    let componentFilter = "name contains[c] '\(component)'"
                    
                    var componentMatches = matches
                    if componentMatches == nil {
                        componentMatches = realm.objects(DvrShow.self)
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
