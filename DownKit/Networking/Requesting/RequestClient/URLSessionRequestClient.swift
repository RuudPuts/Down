//
//  URLSessionRequestClient.swift
//  DownKit
//
//  Created by Ruud Puts on 18/07/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import RxSwift

extension URLSession: RequestClient {
    public func execute(_ request: Request) -> Observable<Response> {
        return Observable.create { observable in
            guard let request = request.asUrlRequest() else {
                observable.onError(RequestClientError.invalidRequest)
                return Disposables.create()
            }

            NSLog("Request: \(request.debugDescription)")

            self.dataTask(with: request) { (data, response, error) in
                guard error == nil else {
                    return observable.onError(RequestClientError.generic(message: error!.localizedDescription))
                }

                guard let httpResponse = response as? HTTPURLResponse else {
                    return observable.onError(RequestClientError.invalidResponse)
                }

                guard let data = data else {
                    return observable.onError(RequestClientError.noData)
                }

                observable.onNext(Response(
                    data: data,
                    statusCode: httpResponse.statusCode,
                    headers: httpResponse.allHeaderFields as? [String: String]
                ))
            }.resume()

            return Disposables.create()
        }
    }
}

extension Request {
    func asUrlRequest() -> URLRequest? {
        guard let url = URL.fromHost(host: self.url) else {
            return nil
        }

        var request = URLRequest(url: url)
        request.httpMethod = self.method.rawValue

        switch authenticationMethod {
        case .none:
            break
        case .basic:
            configureBasicAuthentication(for: &request)
            break
        case .form:
            configureFormAuthentication(for: &request)
            break
        }

        return request
    }

    func configureBasicAuthentication(for request: inout URLRequest) {
        guard let username = basicAuthenticationData?.username, let password = basicAuthenticationData?.password,
            let authString = "\(username):\(password)".data(using: .utf8)?.base64EncodedString() else {
                return
        }

        request.setValue("Basic \(authString)", forHTTPHeaderField: "Authorization")
    }

    func configureFormAuthentication(for request: inout URLRequest) {
        guard let fieldName = formAuthenticationData?.fieldName,
              let fieldValue = formAuthenticationData?.fieldValue,
              let authData = ("\(fieldName.username)=\(fieldValue.username)&"
                  + "\(fieldName.password)=\(fieldValue.password)").data(using: .utf8) else {
            return
        }

        request.httpMethod = Method.post.rawValue
        request.httpBody = authData
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
    }
}

extension URL {
    static func fromHost(host: String) -> URL? {
        if !host.hasPrefix("http://") && !host.hasPrefix("https://") {
            return URL(string: "http://\(host)")
        }

        return URL(string: host)
    }
}
