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
    case errorBody
    case loginRequired
    case objectNotFound
    case invalidHeaders
}

enum DownRequestMethod {
    case get
    case post
}

private let DownRequestErrorDomain = "DownKit.DownRequest"

class DownRequest {
    
    // MARK : GET
    
    class func requestData(_ url: String, method: DownRequestMethod = .get, parameters: [String: Any]? = nil,
                           succes: @escaping (Data, [AnyHashable : Any]) -> (Void), error: @escaping (Error) -> (Void)) {
        NSLog("[DownRequest] requesting \(url)")
        Alamofire.request(url).responseData { handler in
            guard handler.result.isSuccess, let response = handler.response else {
                error(downRequestError(for: .requestFailed))
                return
            }
            
            let headers = response.allHeaderFields
            guard validateResponseHeaders(headers) else {
                error(downRequestError(for: .invalidHeaders))
                return
            }
            
            guard let data = handler.result.value else {
                error(downRequestError(for: .emptyBody))
                return
            }
            
            succes(data, headers)
        }
    }
    
    class func requestString(_ url: String, method: DownRequestMethod = .get, parameters: [String: Any]? = nil,
                             succes: @escaping (String, [AnyHashable : Any]) -> (Void), error: @escaping (Error) -> (Void)) {
        requestData(url, method: method, parameters: parameters, succes: { (data, headers) in
            guard let responseString = String(data: data, encoding: .utf8) else {
                error(downRequestError(for: .invalidBody))
                return
            }
            
            succes(responseString, headers)
        }, error: error)
    }
    
    class func requestJson(_ url: String, method: DownRequestMethod = .get, parameters: [String: Any]? = nil,
                           succes: @escaping (JSON, [AnyHashable : Any]) -> (Void), error: @escaping (Error) -> (Void)) {
        requestData(url, method: method, parameters: parameters, succes: { data, headers in
            guard data.endIndex > 0 else {
                error(downRequestError(for: .invalidBody))
                return
            }
            
            let json = JSON(data: data)
            let (jsonValid, errorMessage) = validateJson(json)
            guard jsonValid else {
                error(downRequestError(for: .errorBody, description: errorMessage ?? ""))
                return
            }
            
            succes(json, headers)
        }, error: error)
    }
    
    // MARK: Validation
    
    internal class func validateResponseHeaders(_ headers: [AnyHashable: Any]) -> Bool {
        return true
    }
    
    internal class func validateJson(_ json: JSON) -> (Bool, String?) {
        return (json == JSON.null, nil)
    }
    
    // MARK: Error
    
    internal class func downRequestError(for errorCode: DownRequestError, description: String = "") -> Error {
        var message: String
        switch errorCode {
        case .requestFailed:
            message = "Request failed"
        case .emptyBody:
            message = "Response body is empty"
        case .invalidBody:
            message = "Response body is invalid"
        case .errorBody:
            message = "Response body contains error"
        case .loginRequired:
            message = "Login is required or API key is invalid"
        case .objectNotFound:
            message = "Object not found"
        case .invalidHeaders:
            message = "Reponse headers invalid"
        }
        
        if description.length > 0 {
            message = "\(message) - \(description)"
        }
        
        return downRequestError(message: message)
    }
    
    internal class func downRequestError(message: String) -> Error {
        return NSError(domain: DownRequestErrorDomain, code: 0, userInfo: [NSLocalizedDescriptionKey: message])
    }
    
}
