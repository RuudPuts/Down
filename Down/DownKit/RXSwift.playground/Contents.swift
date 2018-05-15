//: Playground - noun: a place where people can play

import UIKit
import RxSwift

// MARK: Abstraction

// MARK: Movie abstraction



class MovieGateway: RequestGateway {
    var application: Application
    var request: Request

    var movieApplication: MovieApplication? {
        return application as? MovieApplication
    }

    init(application: MovieApplication) {
        self.application = application
    }
}

class MovieListGateway: MovieGateway {

    func execute() {
        guard let request = movieApplication?.request(for: .list) else {
            print("List request not defined for \(application)")
            return
        }

        let executor = RequestExecutor(request: request)
        executor.result.asObservable()
            .subscribe {

            }
        executor.start()
    }
}

// MARK: Movie abstraction - Couchpotato

struct CouchPotatoMovie: Movie, Decodable {
    var imdbIdentifier: String
    var name: String

    enum CodingKeys : String, CodingKey {
        case imdbIdentifier = "imdb"
        case name = "original_title"
    }
}

let couchPotato = MovieApplication(name: "CouchPotato", host: "192.168.2.100:5050", apiKey: "9f45321744254c6d99d6af43a92b65aa")
let gateway = MovieListGateway(application: couchPotato)
gateway.execute()
