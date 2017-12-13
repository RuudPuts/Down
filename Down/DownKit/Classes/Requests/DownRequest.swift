//
//  DownRequest.swift
//  Down
//
//  Created by Ruud Puts on 17/11/16.
//  Copyright © 2016 Ruud Puts. All rights reserved.
//

import Foundation
import Alamofire

enum RequestError: Int {
    case requestFailed
    case emptyBody
    case invalidBody
    case errorBody
    case loginRequired
    case objectNotFound
    case invalidHeaders
}

enum Method: String {
    case options = "OPTIONS"
    case get     = "GET"
    case head    = "HEAD"
    case post    = "POST"
    case put     = "PUT"
    case patch   = "PATCH"
    case delete  = "DELETE"
    case trace   = "TRACE"
    case connect = "CONNECT"
}

enum AuthenticationMethod {
    case basic
    case form
}

struct Credentials {
    var username: String
    var password: String
}

// swiftlint:disable identifier_name
private let DownRequestErrorDomain = "DownKit.DownRequest"

public class DownRequest {
    
    // MARK: GET
    
    class func requestData(_ urls: [String], method: Method = .get, credentials: Credentials? = nil, parameters: [String: Any]? = nil,
                           succes: @escaping (Data, [AnyHashable: Any]) -> Void, error: @escaping () -> Void) {
        let group = DispatchGroup()
        group.enter()
        
        urls.forEach { (url) in
            group.enter()
            requestData(url, method: method, credentials: credentials, parameters: parameters, succes: { string, headers in
                succes(string, headers)
                return
            }, error: { _ in
                group.leave()
            })
        }
        
        group.leave()
        group.notify(queue: .global()) {
            error()
        }
        
    }
    
    class func requestData(_ url: String, method: Method = .get, credentials: Credentials? = nil, parameters: [String: Any]? = nil,
                           succes: @escaping (Data, [AnyHashable: Any]) -> Void, error: @escaping (Error) -> Void) {
        var parameters = parameters
        if let credentials = credentials, authenticationMethod() == .form {
            var resolvedParameters = parameters ?? [String: Any]()
            resolvedParameters["username"] = credentials.username
            resolvedParameters["password"] = credentials.password
            
            parameters = resolvedParameters
        }

        var request = Alamofire.request(url, method: mapMethod(method), parameters: parameters)
        if let credentials = credentials, authenticationMethod() == .basic {
            request = request.authenticate(user: credentials.username, password: credentials.password)
        }
        
        request.responseData { handler in
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
    
    class func requestString(_ urls: [String], method: Method = .get, credentials: Credentials? = nil, parameters: [String: Any]? = nil,
                             succes: @escaping (String, [AnyHashable: Any]) -> Void, error: @escaping () -> Void) {
        
        let group = DispatchGroup()
        group.enter()
        
        urls.forEach { (url) in
            group.enter()
            requestString(url, method: method, credentials: credentials, parameters: parameters, succes: { string, headers in
                succes(string, headers)
                return
            }, error: { _ in
                group.leave()
            })
        }
        
        group.leave()
        group.notify(queue: .global()) {
            error()
        }
        
    }
    
    class func requestString(_ url: String, method: Method = .get, credentials: Credentials? = nil, parameters: [String: Any]? = nil,
                             succes: @escaping (String, [AnyHashable: Any]) -> Void, error: @escaping (Error) -> Void) {
        requestData(url, method: method, credentials: credentials, parameters: parameters, succes: { (data, headers) in
            guard let responseString = String(data: data, encoding: .utf8) else {
                error(downRequestError(for: .invalidBody))
                return
            }
            
            succes(responseString, headers)
        }, error: error)
    }

    class func requestJson(_ urls: [String], method: Method = .get, credentials: Credentials? = nil, parameters: [String: Any]? = nil,
                           succes: @escaping (JSON, [AnyHashable: Any]) -> Void, error: @escaping () -> Void) {
     
        let group = DispatchGroup()
        group.enter()
        
        urls.forEach { (url) in
            group.enter()
            requestJson(url, method: method, credentials: credentials, parameters: parameters, succes: { json, headers in
                succes(json, headers)
                return
            }, error: { _ in
                group.leave()
            })
        }
        
        group.leave()
        group.notify(queue: .global()) {
            error()
        }
        
    }
    
    class func requestJson(_ url: String, method: Method = .get, credentials: Credentials? = nil, parameters: [String: Any]? = nil,
                           succes: @escaping (JSON, [AnyHashable: Any]) -> Void, error: @escaping (Error) -> Void) {
        requestData(url, method: method, credentials: credentials, parameters: parameters, succes: { data, headers in
            guard data.endIndex > 0 else {
                error(downRequestError(for: .invalidBody))
                return
            }

            do {
                let json = try JSON(data: data)
                let (jsonValid, errorMessage) = validateJson(json)
                guard jsonValid else {
                    error(downRequestError(for: .errorBody, description: errorMessage ?? ""))
                    return
                }

                succes(json, headers)
            }
            catch {
                // TODO error closure isn't reachable?
//                error(downRequestError(for: .errorBody, description: error.localizedDescription))
                return
            }
        }, error: error)
    }
    
    // MARK: Requests
    
    fileprivate class func mapMethod(_ method: Method) -> HTTPMethod {
        return HTTPMethod(rawValue: method.rawValue)!
    }
    
    internal class func authenticationMethod() -> AuthenticationMethod {
        return .form
    }
    
    // MARK: Validation
    
    internal class func validateResponseHeaders(_ headers: [AnyHashable: Any]) -> Bool {
        return true
    }
    
    internal class func validateJson(_ json: JSON) -> (Bool, String?) {
        return (json != JSON.null, nil)
    }
    
    // MARK: Error
    
    internal class func downRequestError(for errorCode: RequestError, description: String = "") -> Error {
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
