//
//  DmrDatabaseMock.swift
//  DownKitTests
//
//  Created by Ruud Puts on 30/09/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

@testable import DownKit
import RxSwift

class DmrDatabaseMock: DmrDatabase {
    struct Stubs {
        var fetchMovies = Observable<[DmrMovie]>.just([])
        var fetchMovieMatchingNameComponents = Maybe<DmrMovie>.just(DmrMovie())
    }
    
    struct Captures {
        var storeMovie: Movie?
        var deleteMovie: Movie?
        var fetchMovies: Bool?
        var fetchMovieMatching: FetchMovieMatching?
        
        struct Movie {
            var movie: DmrMovie
        }

        struct FetchMovieMatching {
            var nameComponents: [String]
        }
    }
    
    var stubs = Stubs()
    var captures = Captures()
    
    // DmrDatabase
    
    func store(movie: DmrMovie) {
        captures.storeMovie = Captures.Movie(movie: movie)
    }

    func delete(movie: DmrMovie) {
        captures.deleteMovie = Captures.Movie(movie: movie)
    }
    
    func fetchMovies() -> Observable<[DmrMovie]> {
        captures.fetchMovies = true
        return stubs.fetchMovies
    }
    
    func fetchMovie(matching nameComponents: [String]) -> Maybe<DmrMovie> {
        captures.fetchMovieMatching = Captures.FetchMovieMatching(nameComponents: nameComponents)
        return stubs.fetchMovieMatchingNameComponents
    }
    
    func transact(block: @escaping () -> Void) {
        block()
    }
}
