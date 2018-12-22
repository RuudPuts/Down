//
//  PagingViewModel.swift
//  Down
//
//  Created by Ruud Puts on 22/12/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import RxSwift
import RxCocoa

protocol PagingViewModel {
    var dataLoadDescription: String { get }

    func transform(input: PagingViewModelInput) -> PagingViewModelOutput
}

struct PagingViewModelInput {
    let loadData: Observable<Void>
}

struct PagingViewModelOutput {
    let data: Driver<Void>
    let loadingData: Driver<Bool>
}
