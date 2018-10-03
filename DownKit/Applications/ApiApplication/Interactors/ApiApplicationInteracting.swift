//
//  ApiApplicationInteracting.swift
//  DownKit
//
//  Created by Ruud Puts on 15/07/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

public protocol ApiApplicationInteracting {
    //! If view controllers where to be bulid in xibs these shouldn't hvae to be implicit unwrapped
    var apiApplication: ApiApplication! { get set }
    var apiInteractorFactory: ApiApplicationInteractorProducing! { get set }
}
