//
//  ShowsViewModel.swift
//  Down
//
//  Created by Ruud Puts on 13/11/16.
//  Copyright © 2016 Ruud Puts. All rights reserved.
//

import DownKit
import Nuke
import Preheat

class ShowsViewModel: NSObject {
    var shows = [SickbeardShow]()
    var delegate: ShowsViewModelDelegate?
}

protocol ShowsViewModelDelegate {
    func viewModel(_ model: ShowsViewModel, didSelectShow show: SickbeardShow)
}

extension UIResponder {
    var parentViewController: DownViewController? {
        if let next = self.next {
            if next is DownViewController {
                return next as? DownViewController
            }
            else {
                return next.parentViewController
            }
        }
        
        return nil
    }
}

extension SickbeardShow {
    
    var posterThumbnailRequest: Request {
        get {
            let filePath = UIApplication.documentsDirectory + "/sickbeard/posters/\(tvdbId)_thumb.png"
            
            return Request(url: URL(fileURLWithPath: filePath))
        }
    }
}
