//
//  DvrShowsViewModel.swift
//  Down
//
//  Created by Ruud Puts on 03/08/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import DownKit
import RxSwift
import RxCocoa

struct DvrShowsViewModel: Depending {
    typealias Dependencies = DatabaseDependency
    let dependencies: Dependencies

    let title = "All shows"

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
}

extension DvrShowsViewModel: ReactiveBindable {
    struct Input { }

    struct Output {
        let shows: Driver<[DvrShow]>
    }

    func transform(input: Input) -> Output {
        let showsDriver = dependencies.database
            .fetchShows()
            .map { $0.sorted(by: { $0.nameWithoutPrefix < $1.nameWithoutPrefix }) }
            .asDriver(onErrorJustReturn: [])

        return Output(shows: showsDriver)
    }
}

private extension DvrShow {
    var nameWithoutPrefix: String {
        return name.removingPrefixes(["a", "the"])
    }
}

// From https://stackoverflow.com/a/47469059
private extension String {
    func removingPrefixes(_ prefixes: [String]) -> String {
        let pattern = "^(\(prefixes.map { "\\Q"+$0+"\\E" }.joined(separator: "|")))\\s?"
        guard let range = self.range(of: pattern, options: [.regularExpression, .caseInsensitive]) else {
            return self
        }

        return String(self[range.upperBound...])
    }
}
