//
//  DownloadResponseParsing.swift
//  Down
//
//  Created by Ruud Puts on 22/06/2018
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import Result

public protocol DownloadResponseParsing: ApiApplicationResponseParsing {
    func parseQueue(from response: Response) -> Result<DownloadQueue, DownKitError>
    func parseHistory(from response: Response) -> Result<[DownloadItem], DownKitError>
    func parseDeleteItem(from response: Response) -> Result<Bool, DownKitError>
}
