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
    public init() {}

    public func execute(_ request: Request) -> Observable<Response> {
        return Observable<Response>.create { observable in
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
        guard let url = URL.fromHost(host: self.url) else {
            return nil
        }

        var parameters: [String: Any] = [:]
        if let authData = formAuthenticationData, authenticationMethod == .form {
            parameters[authData.fieldName.username] = authData.fieldValue.username
            parameters[authData.fieldName.password] = authData.fieldValue.password
        }

        let method = HTTPMethod(rawValue: self.method.rawValue.uppercased())!
        var request = Alamofire.request(url.absoluteString, method: method, parameters: parameters)

        if let authData = basicAuthenticationData, authenticationMethod == .basic {
            request = request.authenticate(user: authData.username, password: authData.password)
        }

        return request
    }
}
