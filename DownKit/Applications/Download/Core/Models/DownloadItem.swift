//
//  DownloadItem.swift
//  DownKit
//
//  Created by Ruud Puts on 22/06/2018
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import RxSwift

public class DownloadItem {
    public let identifier: String
    public let name: String
    public let category: String
    public let sizeMb: Double
    public let progress: Double
    public var dvrEpisode: DvrEpisode?
        
    public init(identifier: String, name: String, category: String, sizeMb: Double, progress: Double) {
        self.identifier = identifier
        self.name = name
        self.category = category
        self.sizeMb = sizeMb
        self.progress = progress
    }
}

extension DownloadItem {
    public func match(with database: DvrDatabase) -> Single<DownloadItem> {
        guard let (seasonIdentifier, episodeIdentifier, seasonEpisodeString) = seasonAndEpisode(in: name) else {
            return Single.just(self)
        }

        let nameComponents = self.name.components(separatedBy: seasonEpisodeString)
            .first!
            .components(separatedBy: ".")
            .filter { !$0.isEmpty }

        return database
            .fetchShow(matching: nameComponents)
            .map {
                $0?.seasons.first(where: {
                    $0.identifier == String(seasonIdentifier)
                })
            }
            .map {
                $0?.episodes.first(where: {
                    $0.identifier == String(episodeIdentifier)
                })
            }
            .do(onSuccess: { self.dvrEpisode = $0 })
            .map { _ in self }
            .asObservable()
            .asSingle()
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
