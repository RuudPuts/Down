//
//  DownRequest.swift
//  Down
//
//  Created by Ruud Puts on 17/11/16.
//  Copyright © 2016 Ruud Puts. All rights reserved.
//

import Foundation
import Alamofire

enum DownRequestError: Int {
    case requestFailed
    case emptyBody
    case invalidBody
    case loginRequired
    case objectNotFound
}

private let DownRequestErrorDomain = "DownKit.DownRequest"

class DownRequest {
    
    // MARK : GET
    
    class func requestData(_ url: String, succes: @escaping (Data, [AnyHashable : Any]) -> (Void), error: @escaping (Error) -> (Void)) {
        NSLog("[DownRequest] requesting \(url)")
        Alamofire.request(url).responseData { handler in
            guard handler.result.isSuccess, let response = handler.response else {
                error(downRequestError(for: .requestFailed))
                return
            }
            
            guard let data = handler.result.value else {
                error(downRequestError(for: .emptyBody))
                return
            }
            
            succes(data, response.allHeaderFields)
        }
    }
    
    class func requestString(_ url: String, succes: @escaping (String, [AnyHashable : Any]) -> (Void), error: @escaping (Error) -> (Void)) {
        requestData(url, succes: { (data, headers) in
            guard let responseString = String(data: data, encoding: .utf8) else {
                error(downRequestError(for: .invalidBody))
                return
            }
            
            succes(responseString, headers)
        }, error: error)
    }
    
    class func requestJson(_ url: String, succes: @escaping (JSON, [AnyHashable : Any]) -> (Void), error: @escaping (Error) -> (Void)) {
        requestData(url, succes: { data, headers in
            guard data.endIndex > 0 else {
                error(downRequestError(for: .invalidBody))
                return
            }
            
            succes(JSON(data: data), headers)
        }, error: error)
    }
    
    // MARK: POST
    
    class func postData(_ url: String, parameters: [String: Any], succes: @escaping (Data, [AnyHashable : Any]) -> (Void), error: @escaping (Error) -> (Void)) {
        NSLog("[DownRequest] requesting \(url)")
        Alamofire.request(url, method: .post, parameters: parameters).responseData { handler in
            guard handler.result.isSuccess, let response = handler.response else {
                error(downRequestError(for: .requestFailed))
                return
            }
            
            guard let data = handler.result.value else {
                error(downRequestError(for: .emptyBody))
                return
            }
            
            succes(data, response.allHeaderFields)
        }
    }
    
    class func postString(_ url: String, parameters: [String: Any], succes: @escaping (String, [AnyHashable : Any]) -> (Void), error: @escaping (Error) -> (Void)) {
        postData(url, parameters: parameters, succes: { (data, headers) in
            guard let responseString = String(data: data, encoding: .utf8) else {
                error(downRequestError(for: .invalidBody))
                return
            }
            
            succes(responseString, headers)
        }, error: error)
    }
    
    // MARK: Error
    
    internal class func downRequestError(for errorCode: DownRequestError) -> Error {
        var message: String
        switch errorCode {
        case .requestFailed:
            message = "Request failed"
        case .emptyBody:
            message = "Response body is empty"
        case .invalidBody:
            message = "Response body is invalid"
        case .loginRequired:
            message = "Login is required or API key is invalid"
        case .objectNotFound:
            message = "Object not found"
        }
        
        return downRequestError(message: message)
    }
    
    internal class func downRequestError(message: String) -> Error {
        return NSError(domain: DownRequestErrorDomain, code: 0, userInfo: [NSLocalizedDescriptionKey: message])
    }
    
}
