//
//  ApplicationSettingsChangedAction.swift
//  Down
//
//  Created by Ruud Puts on 24/07/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import DownKit
import RxSwift

protocol ApplicationSettingsChangedAction {
    associatedtype Interactor: ObservableInteractor

    var title: String { get }
    var interactor: Interactor { get }

    init(title: String, interactor: Interactor)
}
