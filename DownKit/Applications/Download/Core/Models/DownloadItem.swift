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
    public var dvrEpisode: DvrEpisode?
    
    let disposeBag = DisposeBag()
    
    public init(identifier: String, name: String) {
        self.identifier = identifier
        self.name = name
    }
}

extension DownloadItem: DvrDatabaseMatching {
    func match(with database: DvrDatabase) {
        guard let (season, episode, string) = seasonAndEpisode(in: name) else {
            return
        }
        
        let nameComponents = name.components(separatedBy: string)
                                 .first!
                                 .components(separatedBy: ".")
        database.fetchShow(matching: nameComponents)
            .subscribe(onNext: { show in
                let seasonId = season - 1
                let episodeId = episode - 1
                
                if show.seasons.count > seasonId
                    && show.seasons[seasonId].episodes.count > episodeId {
                    self.dvrEpisode = show.seasons[seasonId].episodes[episodeId]
                }
            })
            .disposed(by: disposeBag)
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
