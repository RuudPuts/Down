//
//  CircleProgressViewExtensions.swift
//  Down
//
//  Created by Ruud Puts on 20/11/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import RxSwift
import RxCocoa
import CircleProgressView

extension Reactive where Base: CircleProgressView {
    var progress: Binder<Double> {
        return Binder(base) { progressView, progress in
            progressView.progress = progress
        }
    }
}
