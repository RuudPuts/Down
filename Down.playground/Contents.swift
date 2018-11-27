import PlaygroundSupport
import UIKit
import RxSwift
import Result
import RxResult
import DownKit

enum DownKitError: Error {
    case requestExecutor(RequestExecutingError)
}

let bag = DisposeBag()

let observable = Observable<Result<Int, DownKitError>>.create { observer in
    DispatchQueue.global().async {
        while true {
            let i = Int.random(in: 0...12)

            if i < 8 {
                observer.onNext(.success(i))
            }
            else {
                observer.onNext(.failure(.requestExecutor(.invalidRequest)))
            }

            sleep(3)
        }
    }

    return Disposables.create()
}



observable
    .map { $0.map { String($0) }}
    .subscribeResult(
        onSuccess: { aaa in
            print("\(type(of: aaa)): \(aaa)")
        },
        onFailure: { error in
            print(error)
        }
    )
    .disposed(by: bag)

PlaygroundPage.current.needsIndefiniteExecution = true
