//
//  DownloadApplicationInteracting.swift
//  DownKit
//
//  Created by Ruud Puts on 22/06/2018
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

public protocol DownloadApplicationInteracting {
    var application: DownloadApplication! { get set }
    var interactorFactory: DownloadInteractorProducing! { get set }
}
