//
//  DmrApplicationInteracting.swift
//  DownKit
//
//  Created by Ruud Puts on 17/06/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

public protocol DmrApplicationInteracting {
    //! If view controllers where to be bulid in xibs these shouldn't hvae to be implicit unwrapped
    var application: DmrApplication! { get set }
//    var interactorFactory: DmrInteractorProducing! { get set }
}
