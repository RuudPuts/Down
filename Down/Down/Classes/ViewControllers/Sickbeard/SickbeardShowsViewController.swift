//
//  SickbeardShowsViewController.swift
//  Down
//
//  Created by Ruud Puts on 19/09/15.
//  Copyright (c) 2015 Ruud Puts. All rights reserved.
//

import UIKit
import DownKit

class SickbeardShowsViewController: DownViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    weak var sickbeardService: SickbeardService!
    
    convenience init() {
        self.init(nibName: "SickbeardShowsViewController", bundle: nil)
        
        title = "Shows"
        sickbeardService = serviceManager.sickbeardService
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cellNib = UINib(nibName: "SickbeardShowCell", bundle:nil)
        collectionView.registerNib(cellNib, forCellWithReuseIdentifier: "SickbeardShowCell")
        
        
    }
    
    // MARK: - CollectionView DataSource
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sickbeardService.shows.count
    }
    
    func collectionView(collectionView: UICollectionView, isSectionEmtpy section: Int) -> Bool {
        return sickbeardService.shows.count == 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let show = Array(sickbeardService.shows)[indexPath.row]
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("SickbeardShowCell", forIndexPath: indexPath) as! SickbeardShowCell
        cell.setCellType(.Sickbeard)
        cell.label?.text = show.name
        cell.posterView?.image = show.poster
        
        return cell
    }
    
    // MARK: - CollectionView Delegate
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let cellWidth = self.view.frame.width / 3
        let cellHeight = (cellWidth / 66 * 100) + 30
        
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let show = Array(sickbeardService.shows)[indexPath.row]
        
        let showViewController = SickbeardShowViewController(show: show)
        navigationController?.pushViewController(showViewController, animated: true)
    }
    
}
