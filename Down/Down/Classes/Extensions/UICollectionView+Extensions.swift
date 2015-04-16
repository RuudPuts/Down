//
//  UICollectionView+Extensions.swift
//  Down
//
//  Created by Ruud Puts on 07/04/15.
//  Copyright (c) 2015 Ruud Puts. All rights reserved.
//

import UIKit

extension UICollectionView {
    
    func dequeueReusableCell(cellIdentifier: String!, indexPath: NSIndexPath!) -> AnyObject {
        return self.dequeueReusableCellWithReuseIdentifier(cellIdentifier, forIndexPath: indexPath)
    }
    
}