//
//  ObservableResult.swift
//  DownKit
//
//  Created by Stefan Renne on 18/07/2019.
//  Copyright © 2019 Mobile Sorcery. All rights reserved.
//

import Foundation
import RxSwift

public protocol RxResultError: Error {
    static func failure(from error: Error) -> Self
}

extension Swift.Result {
    public var value: Success? {
        guard case .success(let value) = self else {
            return nil
        }
        return value
    }
}

extension ObservableType {
    
    public func subscribe<S, E: Error>(onSuccess: ((S) -> Void)? = nil, onFailure:((E) -> Void)? = nil) -> Disposable where Element == Swift.Result<S, E> {
        
        return self.subscribe(onNext: { (result) in
            switch result {
            case .success(let value):
                onSuccess?(value)
            case .failure(let error):
                onFailure?(error)
            }
        })
    }
    
    public func `do`<S, E: Error>(onSuccess: ((S) -> Void)? = nil, onFailure:((E) -> Void)? = nil) -> Observable<Swift.Result<S, E>> where Element == Swift.Result<S, E> {
        
        return self.do(onNext: { (result) in
            switch result {
            case .success(let value):
                onSuccess?(value)
            case .failure(let error):
                onFailure?(error)
            }
        })
    }
    
    public func `map`<S, Result, E: RxResultError>(_ transform: @escaping (S) throws -> Result) -> Observable<Swift.Result<Result, E>> where Element == Swift.Result<S, E> {
        
        return self.map({ (result) -> Swift.Result<Result, E> in
            do {
                switch result {
                case .success(let value):
                    let result = try transform(value)
                    return .success(result)
                case .failure(let error):
                    return .failure(error)
                }
            } catch {
                return .failure(E.failure(from: error))
            }
        })
    }
    
    public func mapResult<U: RxResultError>(_ errorType: U.Type) -> Observable<Swift.Result<Element, U>> {
        return self
            .map(Swift.Result<Element, U>.success)
            .catchError { error in
                if let error = error as? U {
                    return .just(Result.failure(error))
                }
                return .just(Result.failure(U.failure(from: error))) }
    }
}
