//
//  DownloadItem.swift
//  DownKit
//
//  Created by Ruud Puts on 22/06/2018
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import RxSwift

public final class DownloadItem {
    public let identifier: String
    public let name: String
    public var dvrEpisode: DvrEpisode?
    
    let disposeBag = DisposeBag()
    
    public init(identifier: String, name: String) {
        self.identifier = identifier
        self.name = name
    }
}

extension DownloadItem: DvrDatabaseMatching {
    public func match(with database: DvrDatabase) -> Observable<DownloadItem> {
        guard let (seasonIdentifier, episodeIdentifier, seasonEpisodeString) = seasonAndEpisode(in: name) else {
            return Observable.just(self)
        }

        return Observable<DownloadItem>.create { observer in
            let complete = {
                observer.onNext(self)
            }

                let nameComponents = self.name.components(separatedBy: seasonEpisodeString)
                    .first!
                    .components(separatedBy: ".")
                    .filter { $0.count > 0}

                database
                    .fetchShow(matching: nameComponents)
                    .subscribe { event in
                        switch event {
                        case .success(let show):
                            self.dvrEpisode = show
                                .seasons.first(where: {
                                    $0.identifier == String(seasonIdentifier)
                                })?
                                .episodes.first(where: {
                                    $0.identifier == String(episodeIdentifier)
                                })
                        default: break
                        }

                        observer.onNext(self)
                    }
                    .disposed(by: self.disposeBag)

                    return Disposables.create()
            }
    }
    
    // swiftlint:disable large_tuple
    func seasonAndEpisode(in string: String) -> (Int, Int, String)? {
        let (range, matches) = string.match("S(\\d+).?E(\\d+)")
        guard range.location != NSNotFound && matches.count == 3 else {
            return nil
        }
        
        guard let season = Int(matches[1]), let episode = Int(matches[2]) else {
            return nil
        }
        
        return (season, episode, matches[0])
    }
}

extension String {
    func match(_ regex: String) -> (range: NSRange, groups: [String]) {
        do {
            let regex = try NSRegularExpression(pattern: regex, options: .caseInsensitive)
            guard let match = regex.matches(in: self, options: [], range: NSRange(location: 0, length: self.count)).first else {
                return (NSRange(), [])
            }
            
            var groups = [String]()
            for i in 0..<match.numberOfRanges {
                let group = String(NSString(string: self).substring(with: match.range(at: i)))
                groups.append(group)
            }
            
            return (match.range, groups)
        }
        catch {
            return (NSRange(), [])
        }
    }
}
