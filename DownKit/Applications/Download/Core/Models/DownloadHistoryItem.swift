//
//  DownloadHistoryItem.swift
//  DownKit
//
//  Created by Ruud Puts on 13/08/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import UIKit

public class DownloadHistoryItem: DownloadItem {
    public var state: State
    public var finishDate: Date?

    public enum State {
        case unknown
        case queued
        case verifying
        case repairing
        case extracting
        case postProcessing
        case failed
        case completed

        public var hasProgress: Bool {
            switch self {
            case .verifying, .repairing, .extracting:
                return true
            default:
                return false
            }
        }
    }

    init(identifier: String, name: String, category: String, sizeMb: Double, progress: Double, finishDate: Date?, state: State) {
        self.finishDate = finishDate
        self.state = state
        super.init(identifier: identifier, name: name, category: category, sizeMb: sizeMb, progress: progress)
    }
}
