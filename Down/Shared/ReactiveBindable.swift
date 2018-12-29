//
//  ReactiveBindable.swift
//  Down
//
//  Created by Ruud Puts on 18/11/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

protocol ReactiveBindable {
    associatedtype Input
    associatedtype Output

    var input: Input { get }
    var output: Output { mutating get }

    func transform(input: Input) -> Output
}

protocol ReactiveBinding {
    associatedtype Bindable: ReactiveBindable

    func bind(to bindable: Bindable)
    func bind(input: Bindable.Input)
    func bind(output: Bindable.Output)
}

extension ReactiveBinding {
    func bind(to bindable: Bindable) {
        var bindable = bindable //! This might copy the view model if it's a struct?

        bind(input: bindable.input)
        bind(output: bindable.output)
    }

    func bind(input: Bindable.Input) { }
}
