//
//  DownSectionIndexView.swift
//  Down
//
//  Created by Ruud Puts on 26/09/16.
//  Copyright © 2016 Ruud Puts. All rights reserved.
//

import UIKit

class DownSectionIndexView: UIView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var indexView: UICollectionView!
    weak var tableView: UITableView?
    weak var collectionView: UICollectionView?
    
    var delegate: DownSectionIndexViewDelegate?
    
    var datasource = [String]() {
        didSet {
            indexView.heightConstraint?.constant = CGFloat(datasource.count) * indexView.bounds.width
            indexView.reloadData()
        }
    }
    
    override func awakeFromNib() {
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(collectionViewPanned))
        indexView.addGestureRecognizer(panGestureRecognizer)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datasource.count
    }
    
    func collectionView(_ indexView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = indexView.dequeueReusableCell(withReuseIdentifier: "SectionIndexCell", for: indexPath) as! DownCollectionViewCell
        cell.label.text = datasource[(indexPath as NSIndexPath).item]
        cell.cellColor = .white
        
        return cell
    }
    
    func collectionView(_ indexView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedIndex = (indexPath as NSIndexPath).item
        
        if let delegate = delegate {
            delegate.sectionIndexView(self, didSelectSection: datasource[selectedIndex], atIndex: selectedIndex)
        }
        else {
            let tableViewIndex = IndexPath(row: 0, section: selectedIndex)
            tableView?.scrollToRow(at: tableViewIndex, at: .top, animated: false)
            let collectionViewIndex = IndexPath(item: 0, section: selectedIndex)
            collectionView?.scrollToItem(at: collectionViewIndex, at: .top, animated: false)
        }
    }
    
    func collectionViewPanned(_ recognizer: UIPanGestureRecognizer) {
        var touch = recognizer.location(in: indexView)
        touch.x = self.bounds.midX
        
        if let indexPath = indexView.indexPathForItem(at: touch) {
            collectionView(indexView, didSelectItemAt: indexPath)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let viewWidth = collectionView.bounds.width
        let viewHeight = collectionView.bounds.height
        let cellsHeight = CGFloat(datasource.count) * collectionView.bounds.width
        
        return CGSize(width: viewWidth, height: viewHeight / 2 - cellsHeight / 2)
    }
    
}

protocol DownSectionIndexViewDelegate {
    
    func sectionIndexView(_ sectionIndexView: DownSectionIndexView, didSelectSection section: String, atIndex index: Int)
    
}
