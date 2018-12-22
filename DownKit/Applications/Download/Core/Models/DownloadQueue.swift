//
//  DownloadQueue.swift
//  DownKit
//
//  Created by Ruud Puts on 23/06/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

public class DownloadQueue {
    public let speedMb: Double
    public let remainingTime: TimeInterval
    public let remainingMb: Double
    public let isPaused: Bool
    
    public let items: [DownloadItem]
    
    public init(speedMb: Double = 0, remainingTime: TimeInterval = 0, remainingMb: Double = 0, isPaused: Bool = false, items: [DownloadItem] = []) {
        self.speedMb = speedMb
        self.remainingTime = remainingTime
        self.remainingMb = remainingMb
        self.isPaused = isPaused
        self.items = items
    }
}
