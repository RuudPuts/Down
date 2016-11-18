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
    
    class func requestData(_ url: String, succes: @escaping (Data) -> (Void), error: @escaping (Error) -> (Void)) {
        Alamofire.request(url).responseData { handler in
            guard handler.result.isSuccess else {
                error(downRequestError(for: .requestFailed))
                return
            }
            
            guard let response = handler.result.value else {
                error(downRequestError(for: .emptyBody))
                return
            }
            
            succes(response)
        }
    }
    
    class func requestString(_ url: String, succes: @escaping (String) -> (Void), error: @escaping (Error) -> (Void)) {
        requestData(url, succes: { responseData in
            guard let responseString = String(data: responseData, encoding: .utf8) else {
                error(downRequestError(for: .invalidBody))
                return
            }
            
            succes(responseString)
        }, error: error)
    }
    
    class func requestJson(_ url: String, succes: @escaping (JSON) -> (Void), error: @escaping (Error) -> (Void)) {
        requestData(url, succes: { responseData in
            guard responseData.endIndex > 0 else {
                error(downRequestError(for: .invalidBody))
                return
            }
            
            succes(JSON(data: responseData))
        }, error: error)
    }
    
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
