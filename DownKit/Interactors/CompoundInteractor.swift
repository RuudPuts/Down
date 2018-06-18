//
//  CompoundInteractor.swift
//  DownKit
//
//  Created by Ruud Puts on 18/06/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

public protocol CompoundInteractor {
    associatedtype Interactors
    var interactors: Interactors { get }
    
    init(interactors: Interactors)
}
