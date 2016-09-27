//
//  DownSectionIndexView.swift
//  Down
//
//  Created by Ruud Puts on 26/09/16.
//  Copyright © 2016 Ruud Puts. All rights reserved.
//

import UIKit

class DownSectionIndexView: UIView, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var indexView: UICollectionView!
    weak var tableView: UITableView?
    weak var collectionView: UICollectionView?
    
    var delegate: DownSectionIndexViewDelegate?
    
    var datasource = [String]() {
        didSet {
            indexView.heightConstraint?.constant = CGFloat(datasource.count) * CGRectGetWidth(indexView.bounds)
            indexView.reloadData()
        }
    }
    
    override func awakeFromNib() {
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(collectionViewPanned))
        indexView.addGestureRecognizer(panGestureRecognizer)
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datasource.count
    }
    
    func collectionView(indexView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = indexView.dequeueReusableCellWithReuseIdentifier("SectionIndexCell", forIndexPath: indexPath) as! DownCollectionViewCell
        cell.label.text = datasource[indexPath.item]
        cell.cellColor = .whiteColor()
        
        return cell
    }
    
    func collectionView(indexView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let selectedIndex = indexPath.item
        
        if let delegate = delegate {
            delegate.sectionIndexView(self, didSelectSection: datasource[selectedIndex], atIndex: selectedIndex)
        }
        else {
            let tableViewIndex = NSIndexPath(forRow: 0, inSection: selectedIndex)
            tableView?.scrollToRowAtIndexPath(tableViewIndex, atScrollPosition: .Top, animated: false)
            let collectionViewIndex = NSIndexPath(forItem: 0, inSection: selectedIndex)
            collectionView?.scrollToItemAtIndexPath(collectionViewIndex, atScrollPosition: .Top, animated: false)
        }
    }
    
    func collectionViewPanned(recognizer: UIPanGestureRecognizer) {
        let touch = recognizer.locationInView(indexView)
        if let indexPath = indexView.indexPathForItemAtPoint(touch) {
            collectionView(indexView, didSelectItemAtIndexPath: indexPath)
        }
    }
    
}

protocol DownSectionIndexViewDelegate {
    
    func sectionIndexView(sectionIndexView: DownSectionIndexView, didSelectSection section: String, atIndex index: Int)
    
}