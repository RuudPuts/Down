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

    public static var defaultConfiguration: Realm.Configuration {
        var configuration = Realm.Configuration.defaultConfiguration
        configuration.deleteRealmIfMigrationNeeded = true

        return configuration
    }
    
    public init(configuration: Realm.Configuration = defaultConfiguration) {
        self.configuration = configuration
    }

    private func makeRealm() -> Realm {
        // swiftlint:disable:next force_try
        return try! Realm(configuration: self.configuration)
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
            realm.delete(show, cascading: true)
        }
    }
    
    public func fetchShows() -> Observable<[DvrShow]> {
        let shows = makeRealm().objects(DvrShow.self)

        return Observable.array(from: shows)
    }
    
    public func fetchShow(matching nameComponents: [String]) -> Single<DvrShow?> {
        return Single.create { observer in
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

            observer(.success(matches?.first))

            return Disposables.create()
        }
    }

    public func store(episode: DvrEpisode) {
        let realm = makeRealm()

        let matchingEpisodes = realm.objects(DvrEpisode.self)
            .filter("uniqueIdentifier == %@", episode.uniqueIdentifier)
        guard !matchingEpisodes.isEmpty else {
            NSLog("[RealmDatabase] store(episode:) should only be used to update episodes")
            return
        }

        try? realm.write {
            realm.add(episode, update: true)
        }
    }

    public func fetchEpisodes(airingOn airDate: Date) -> Observable<[DvrEpisode]> {
        let episodes = makeRealm().objects(DvrEpisode.self)
            .filter("airdate == %@", airDate.withoutTime)
            .sorted(byKeyPath: "airdate")

        return Observable.array(from: episodes)
    }

    public func fetchEpisodes(airingBetween fromDate: Date, and toDate: Date) -> Observable<[DvrEpisode]> {
        let episodes = makeRealm().objects(DvrEpisode.self)
            .filter("airdate >= %@ AND airdate <= %@", fromDate.startOfDay, toDate.endOfDayTime)
            .sorted(byKeyPath: "airdate")

        return Observable.array(from: episodes)
    }
}
