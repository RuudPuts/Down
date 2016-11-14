//
//  ShowsCollectionViewModel.swift
//  Down
//
//  Created by Ruud Puts on 12/11/16.
//  Copyright © 2016 Ruud Puts. All rights reserved.
//

import UIKit
import Preheat
import Nuke

class ShowsCollectionViewModel: ShowsViewModel, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    
    let preheater = Preheater()
    var preheatController: Controller<UICollectionView>!
    
    init(_ collectionView: UICollectionView) {
        preheatController = Controller(view: collectionView)
        super.init()
        
        ["SickbeardShowCell"].forEach {
            let nib = UINib(nibName: $0, bundle: Bundle.main)
            collectionView.register(nib, forCellWithReuseIdentifier: $0)
        }
        
        preheatController.handler = { [weak self] in
            self?.preheatWindowChanged(addedIndexPaths: $0, removedIndexPaths: $1)
        }
    }
    
    // MARK: - Nuke
    
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
    
    // MARK: - CollectionView datasource
    
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
        
        if show.poster == nil {
            
        }
        
        return cell
    }
    
    // MARK: - CollectionView delegate
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let showsPerLine = 3
        // Calculate the width
        var cellWidth = (UIScreen.main.bounds.width - 20) / CGFloat(showsPerLine)
        
        let modulus = (indexPath as NSIndexPath).row % showsPerLine
        if modulus == 0 {
            // Floor the outer left column
            cellWidth = floor(cellWidth)
        }
        else if modulus == showsPerLine - 1 {
            // Ceil the outer right column
            cellWidth = ceil(cellWidth)
        }
        
        // Calculate the height, aspect ration 66:100
        let cellHeight = (cellWidth / 66 * 100)
        
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return collectionView.parentViewController?.searchBar?.bounds.size ?? CGSize.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.viewModel(self, didSelectShow: shows[indexPath.item])
    }
    
}
