//
//  SickbeardShowsViewController.swift
//  Down
//
//  Created by Ruud Puts on 19/09/15.
//  Copyright (c) 2015 Ruud Puts. All rights reserved.
//

import UIKit
import DownKit

class SickbeardShowsViewController: DownDetailViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    weak var sickbeardService: SickbeardService!
    
    convenience init() {
        self.init(nibName: "SickbeardShowsViewController", bundle: nil)
        
        title = "Shows"
        sickbeardService = serviceManager.sickbeardService
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cellNib = UINib(nibName: "SickbeardShowCell", bundle:nil)
        collectionView!.registerNib(cellNib, forCellWithReuseIdentifier: "SickbeardShowCell")
        
        collectionView!.backgroundColor = .downLightGreyColor()
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
        cell.show = show
        
        show.getPosterThumbnail {
            if cell.show == show {
                cell.posterView?.image = $0
            }
        }
        
        return cell
    }
    
    // MARK: - CollectionView Delegate
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let showsPerLine = 3
        // Calculate the widt
        var cellWidth = self.view.frame.width / CGFloat(showsPerLine)
        
        let modulus = indexPath.row % showsPerLine
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
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let show = Array(sickbeardService.shows)[indexPath.row]
        
        let showViewController = SickbeardShowViewController(show: show)
        navigationController?.pushViewController(showViewController, animated: true)
    }
    
}
