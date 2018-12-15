//
//  UITextFieldExtensions.swift
//  Down
//
//  Created by Ruud Puts on 21/11/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

extension Reactive where Base: UITextField {
    var debouncedText: Observable<String> {
        return text.asObservable()
            .debounce(0.3, scheduler: MainScheduler.instance)
            .map { $0 ?? "" }
    }
}
