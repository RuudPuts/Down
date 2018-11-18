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
    public init() { }

    public func execute(_ request: Request) -> Single<Response> {
        return Single.create { observer in
            guard let alamofireRequest = request.asAlamofireRequest() else {
                observer(.error(RequestClientError.invalidRequest))
                return Disposables.create()
            }

            alamofireRequest.responseData { handler in
                guard handler.error == nil else {
                    return observer(.error(RequestClientError.generic(message: handler.error!.localizedDescription)))
                }

                guard let response = handler.response else {
                    return observer(.error(RequestClientError.invalidResponse))
                }

                guard let data = handler.data else {
                    return observer(.error(RequestClientError.noData))
                }

                observer(.success(Response(
                    data: data,
                    statusCode: response.statusCode,
                    headers: response.allHeaderFields as? [String: String]
                )))
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

        let method = HTTPMethod(rawValue: self.method.rawValue.uppercased())!
        var request = Alamofire.request(url.absoluteString,
                                        method: method,
                                        parameters: parameters,
                                        headers: headers)

        if let authData = basicAuthenticationData, authenticationMethod == .basic {
            request = request.authenticate(user: authData.username, password: authData.password)
        }

        return request
    }
}
