//
//  DmrDataStorage.swift
//  DownKit
//
//  Created by Ruud Puts on 30/09/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import RxSwift

public protocol DmrDatabase: Database {
    func store(movie: DmrMovie)
    func delete(movie: DmrMovie)
    func fetchMovies() -> Observable<[DmrMovie]>
    func fetchMovie(matching nameComponents: [String]) -> Maybe<DmrMovie>
}

protocol DmrDatabaseStoring {
    func store(in database: DmrDatabase)
}
