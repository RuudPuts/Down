//
//  DvrApplicationInteracting.swift
//  DownKit
//
//  Created by Ruud Puts on 17/06/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

public protocol DvrApplicationInteracting {
    //! If view controllers where to be bulid in xibs these shouldn't hvae to be implicit unwrapped
    var application: DvrApplication! { get set }
    var interactorFactory: DvrInteractorProducing! { get set }
}
