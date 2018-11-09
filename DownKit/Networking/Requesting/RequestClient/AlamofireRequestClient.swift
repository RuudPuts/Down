//
//  AlamofireRequestClient.swift
//  DownKit
//
//  Created by Ruud Puts on 18/07/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import RxSwift
import Alamofire

public class AlamofireRequestClient: RequestClient {
    public init() {
        let manager = Alamofire.SessionManager.default

        manager.delegate.taskWillPerformHTTPRedirection = { session, task, response, request in
            print("REDIRECT")
            print("  Request: \(request)")

            var request = request
            if let cookieStorage = session.configuration.httpCookieStorage,
               let responseUrl = response.url,
               let cookies = cookieStorage.cookies(for: responseUrl) {
                cookies.forEach {
                    request.setValue("Cookie", forHTTPHeaderField: "\($0.name)=\($0.value)")
                }
            }

            print("     \(request.allHTTPHeaderFields)")
            print("  Response: \(response)")
            print("     \(response.allHeaderFields)")
            return request
        }
    }

    public func execute(_ request: Request) -> Observable<Response> {
        return Observable.create { observable in
            guard let alamofireRequest = request.asAlamofireRequest() else {
                observable.onError(RequestClientError.invalidRequest)
                return Disposables.create()
            }

            alamofireRequest.responseData { handler in
                guard handler.error == nil else {
                    return observable.onError(RequestClientError.generic(message: handler.error!.localizedDescription))
                }

                guard let response = handler.response else {
                    return observable.onError(RequestClientError.invalidResponse)
                }

                guard let data = handler.data else {
                    return observable.onError(RequestClientError.noData)
                }

                observable.onNext(Response(
                    data: data,
                    statusCode: response.statusCode,
                    headers: response.allHeaderFields as? [String: String]
                ))
            }

            return Disposables.create()
        }
    }
}

extension Request {
    func asAlamofireRequest() -> DataRequest? {
        var parameters: [String: Any]?
        if let authData = formAuthenticationData, authenticationMethod == .form {
            parameters = authData
        }

        var cookiedHeaders = headers ?? [:]
        if let cookieStorage = URLSession.shared.configuration.httpCookieStorage,
            let cookies = cookieStorage.cookies(for: url) {
            cookies.forEach {
                cookiedHeaders["Cookie"] = "\($0.name)=\"\($0.value)\";"
            }
        }

        let method = HTTPMethod(rawValue: self.method.rawValue.uppercased())!
        var request = Alamofire.request(url.absoluteString,
                                        method: method,
                                        parameters: parameters,
                                        headers: cookiedHeaders)

        if let authData = basicAuthenticationData, authenticationMethod == .basic {
            request = request.authenticate(user: authData.username, password: authData.password)
        }

        return request
    }
}
