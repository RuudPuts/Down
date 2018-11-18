//
//  ReactiveBindable.swift
//  Down
//
//  Created by Ruud Puts on 18/11/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import Foundation

protocol ReactiveBindable {
    associatedtype Input
    associatedtype Output

    var input: Input { get }
    var output: Output { get }
}

protocol ReactiveBinding {
    associatedtype Bindable: ReactiveBindable

    func bind(to bindable: Bindable)

    func makeInput() -> Bindable.Input
}

protocol ReactiveTransforming {
    associatedtype Input
    associatedtype Output

    func transform(input: Input) -> Output
}

protocol ReactiveTransformingBinding {
    associatedtype Bindable: ReactiveTransforming

    func bind(to bindable: Bindable)
}

