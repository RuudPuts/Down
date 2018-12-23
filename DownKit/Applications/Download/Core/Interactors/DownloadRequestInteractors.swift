//
//  DownloadRequestInteractors.swift
//  DownKit
//
//  Created by Ruud Puts on 20/10/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

public typealias DownloadPauseQueueInteractor = RequestGatewayInteractor<DownloadPauseQueueGateway>
public typealias DownloadResumeQueueInteractor = RequestGatewayInteractor<DownloadResumeQueueGateway>
public typealias DownloadPurgeHistoryInteractor = RequestGatewayInteractor<DownloadPurgeHistoryGateway>
public typealias DownloadDeleteItemInteractor = RequestGatewayInteractor<DownloadDeleteItemGateway>
