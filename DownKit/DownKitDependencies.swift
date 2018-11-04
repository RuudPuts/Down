//
//  DownKitDependencies.swift
//  DownKit
//
//  Created by Ruud Puts on 04/11/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

public protocol Depending {
    associatedtype Dependencies
    var dependencies: Dependencies { get }
}

public typealias DownKitDependencies = DatabaseDependency
    & ApiApplicationDependency
    & ApiApplicationInteractorFactoryDependency
    & DownloadApplicationDependency
    & DownloadInteractorFactoryDependency
    & DvrApplicationDependency
    & DvrInteractorFactoryDependency
    & DvrRequestBuilderDependency
    & DmrApplicationDependency
    & DmrInteractorFactoryDependency

public protocol DatabaseDependency {
    var database: DownDatabase { get set }
}

public protocol ApiApplicationDependency {
    var apiApplication: ApiApplication! { get set }
}

public protocol ApiApplicationInteractorFactoryDependency: ApiApplicationDependency {
    var apiInteractorFactory: ApiApplicationInteractorProducing! { get set }
}

public protocol DownloadApplicationDependency {
    var downloadApplication: DownloadApplication! { get set }
}

public protocol DownloadInteractorFactoryDependency: DownloadApplicationDependency {
    var downloadInteractorFactory: DownloadInteractorProducing! { get set }
}

public protocol DvrApplicationDependency {
    var dvrApplication: DvrApplication! { get set }
}

public protocol DvrInteractorFactoryDependency: DvrApplicationDependency {
    var dvrInteractorFactory: DvrInteractorProducing! { get set }
}

public protocol DvrRequestBuilderDependency: DvrApplicationDependency {
    var dvrRequestBuilder: DvrRequestBuilding! { get set }
}

public protocol DmrApplicationDependency {
    var dmrApplication: DmrApplication! { get set }
}

public protocol DmrInteractorFactoryDependency: DmrApplicationDependency {
    var dmrInteractorFactory: DmrInteractorProducing! { get set }
}
