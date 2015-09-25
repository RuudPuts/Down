//
//  DatabaseManager.swift
//  Down
//
//  Created by Ruud Puts on 23/09/15.
//  Copyright © 2015 Ruud Puts. All rights reserved.
//

import Foundation

public class DatabaseManager {
    
    let adapter: DatabaseAdapter
    
    class var databasePath: String {
        return UIApplication.documentsDirectory + "/sickbeard/sickbeard.sqlite"
    }
    
    class var databaseExists: Bool {
        return NSFileManager.defaultManager().fileExistsAtPath(databasePath)
    }
    
    public init() {
        adapter = DatabaseV1Adapter()
    }
    
    // MARK: Sickbeard
    
    public func storeSickbeardShow(show: SickbeardShow) {
        adapter.storeSickbeardShow(show)
    }
    
}