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
    public let mbRemaining: String
    
    public let items: [DownloadItem]
    
    public init(currentSpeed: String = "", timeRemaining: String = "", mbRemaining: String = "", items: [DownloadItem] = []) {
        self.currentSpeed = currentSpeed
        self.timeRemaining = timeRemaining
        self.mbRemaining = mbRemaining
        self.items = items
    }

    convenience init() { //! meh
        self.init(currentSpeed: "", timeRemaining: "", mbRemaining: "", items: [])
    }
}
