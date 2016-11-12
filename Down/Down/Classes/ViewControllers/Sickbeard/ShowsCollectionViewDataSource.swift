//
//  ShowsCollectionViewDataSource.swift
//  Down
//
//  Created by Ruud Puts on 12/11/16.
//  Copyright © 2016 Ruud Puts. All rights reserved.
//

import UIKit
import DownKit
import Preheat
import Nuke

class ShowsCollectionViewDataSource: NSObject, UICollectionViewDataSource {
    
    var shows = [SickbeardShow]()
    
    let preheater = Preheater()
    var preheatController: Controller<UICollectionView>!
    
    init(_ collectionView: UICollectionView) {
        preheatController = Controller(view: collectionView)
        super.init()
        
        preheatController.handler = { [weak self] in
            self?.preheatWindowChanged(addedIndexPaths: $0, removedIndexPaths: $1)
        }
    }
    
    func preheatWindowChanged(addedIndexPaths added: [IndexPath], removedIndexPaths removed: [IndexPath]) {
        func requestsForIndexPaths(_ indexPaths: [IndexPath]) -> [Request] {
            var requests = [Request]()
            indexPaths.forEach {
                if $0.item < shows.count {
                    let request = shows[$0.item].posterThumbnailRequest
                    requests.append(request)
                }
            }
            
            return requests
        }
        preheater.startPreheating(with: requestsForIndexPaths(added))
        preheater.stopPreheating(with: requestsForIndexPaths(removed))
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return shows.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let show = shows[indexPath.row]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SickbeardShowCell", for: indexPath) as! SickbeardShowCell
        cell.setCellType(.Sickbeard)
        cell.show = show
        
        Nuke.loadImage(with: show.posterThumbnailRequest, into: cell.posterView)
        
        return cell
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
