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
    public static let `default` = RealmDatabase()
    var realm: Realm!
    
    private var fetchShowsToken: NotificationToken?
    
    public init() {
        transact {
            // swiftlint:disable force_try
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
    
    public func fetchShows() -> Observable<[DvrShow]> {
        return Observable<[DvrShow]>.create { observer in
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
}
