//
//  DownloadQueue.swift
//  DownKit
//
//  Created by Ruud Puts on 23/06/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

public class DownloadQueue {
    public let currentSpeed: String
    public let timeRemaining: String
    public let dataRemaining: String
    
    public let items: [DownloadItem]
    
    init(currentSpeed: String = "", timeRemaining: String = "", dataRemaining: String = "", items: [DownloadItem] = []) {
        self.currentSpeed = currentSpeed
        self.timeRemaining = timeRemaining
        self.dataRemaining = dataRemaining
        self.items = items
    }
}
