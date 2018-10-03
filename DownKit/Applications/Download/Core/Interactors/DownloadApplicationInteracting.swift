//
//  DownloadApplicationInteracting.swift
//  DownKit
//
//  Created by Ruud Puts on 22/06/2018
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

public protocol DownloadApplicationInteracting {
    //! If view controllers where to be bulid in xibs these shouldn't hvae to be implicit unwrapped
    var downloadApplication: DownloadApplication! { get set }
    var downloadInteractorFactory: DownloadInteractorProducing! { get set }
}
