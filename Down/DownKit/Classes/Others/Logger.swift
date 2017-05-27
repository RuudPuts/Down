//
//  Logger.swift
//  Down
//
//  Created by Ruud Puts on 27/05/2017.
//  Copyright © 2017 Ruud Puts. All rights reserved.
//

import Foundation

public let Log = Logger()

public struct Logger {
    
    enum MessageType: String {
        case debug = "🐞"
        case info = "🔍"
        case warning = "⚠️"
        case error = "❗️"
    }
    
    public init() { }
    
    private func log(_ type: MessageType, _ message: String, _ filePath: String, _ line: Int) {
        let file = URL(fileURLWithPath: filePath).pathComponents.last ?? "Unknown"
        print("\(Date()) [\(file):\(line)] \(type.rawValue) \(message)")
    }
    
    public func debug(_ message: String, _ file: String = #file, _ line: Int = #line) {
        log(.debug, message, file, line)
    }
    
    public func d(_ message: String, _ file: String = #file, _ line: Int = #line) {
        debug(message, file, line)
    }
    
    public func info(_ message: String, _ file: String = #file, _ line: Int = #line) {
        log(.info, message, file, line)
    }
    
    public func i(_ message: String, _ file: String = #file, _ line: Int = #line) {
        info(message, file, line)
    }
    
    public func warning(_ message: String, _ file: String = #file, _ line: Int = #line) {
        log(.warning, message, file, line)
    }
    
    public func w(_ message: String, _ file: String = #file, _ line: Int = #line) {
        warning(message, file, line)
    }
    
    public func error(_ message: String, _ file: String = #file, _ line: Int = #line) {
        log(.error, message, file, line)
    }
    
    public func e(_ message: String, _ file: String = #file, _ line: Int = #line) {
        error(message, file, line)
    }
    
}
