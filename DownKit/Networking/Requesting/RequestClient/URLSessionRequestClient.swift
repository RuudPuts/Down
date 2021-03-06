//
//  URLSessionRequestClient.swift
//  DownKit
//
//  Created by Ruud Puts on 18/07/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import RxSwift

extension URLSession: RequestClient {
    public func execute(_ request: Request) -> Single<Response> {
        return Single.create { observer in
            guard let urlRequest = request.asUrlRequest() else {
                observer(.error(RequestClientError.invalidRequest))
                return Disposables.create()
            }

            self.dataTask(with: urlRequest) { (data, response, error) in
                guard error == nil else {
                    return observer(.error(RequestClientError.generic(message: error!.localizedDescription)))
                }

                guard let httpResponse = response as? HTTPURLResponse else {
                    return observer(.error(RequestClientError.invalidResponse))
                }

                guard let data = data else {
                    return observer(.error(RequestClientError.noData))
                }

                observer(.success(Response(
                    data: data,
                    statusCode: httpResponse.statusCode,
                    headers: httpResponse.allHeaderFields as? [String: String]
                )))
            }.resume()

            return Disposables.create()
        }
    }
}

extension Request {
    func asUrlRequest() -> URLRequest? {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers

        switch authenticationMethod {
        case .none:
            break
        case .basic:
            configureBasicAuthentication(for: &request)
        case .form:
            configureFormAuthentication(for: &request)
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
        guard let authData = formAuthenticationData else {
            return
        }

        let requestBody = authData
            .map { "\($0)=\($1)" }
            .joined(separator: "&")

        request.httpMethod = Method.post.rawValue
        request.httpBody = requestBody.data(using: .utf8)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
    }
}

extension URL {
    static func from(host: String) -> URL? {
        if !host.hasPrefix("http://") && !host.hasPrefix("https://") {
            return URL(string: "http://\(host)")
        }

        return URL(string: host)
    }
}
