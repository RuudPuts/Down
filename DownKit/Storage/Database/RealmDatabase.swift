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
    var configuration: Realm.Configuration
    
    public init(configuration: Realm.Configuration = .defaultConfiguration) {
        self.configuration = configuration
    }

    private func makeRealm() -> Realm {
        // swiftlint:disable force_try
        return try! Realm(configuration: self.configuration)
        // swiftlint:enable force_try
    }

    public func store(shows: [DvrShow]) {
        let realm = makeRealm()
        try? realm.write {
            shows.forEach {
                realm.add($0, update: true)
            }
        }
    }

    public func delete(show: DvrShow) {
        let realm = makeRealm()
        try? realm.write {
            realm.delete(show)
        }
    }
    
    public func fetchShows() -> Observable<[DvrShow]> {
        let shows = makeRealm().objects(DvrShow.self)

        return Observable.array(from: shows)
    }
    
    public func fetchShow(matching nameComponents: [String]) -> Maybe<DvrShow> {
        return Maybe.create { observer in
            let realm = self.makeRealm()
            var matches: Results<DvrShow>?

            for component in nameComponents {
                let componentFilter = "name contains[c] '\(component)'"

                var componentMatches = matches
                if componentMatches == nil {
                    componentMatches = realm.objects(DvrShow.self).filter(componentFilter)
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

            return Disposables.create()
        }
    }
}
