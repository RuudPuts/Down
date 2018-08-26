//
//  DownloadQueueItem.swift
//  DownKit
//
//  Created by Ruud Puts on 13/08/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import UIKit

public class DownloadQueueItem: DownloadItem {
    public var remainingMb: Double
    public let remainingTime: TimeInterval
    public var state: State

    public enum State {
        case unknown
        case queued
        case grabbing
        case downloading
    }

    init(identifier: String, name: String, category: String, sizeMb: Double, remainingMb: Double, remainingTime: TimeInterval, progress: Double, state: State) {
        self.remainingMb = remainingMb
        self.remainingTime = remainingTime
        self.state = state
        super.init(identifier: identifier, name: name, category: category, sizeMb: sizeMb, progress: progress)
    }
}
