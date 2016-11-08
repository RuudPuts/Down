//
//  UICollectionView+Extensions.swift
//  Down
//
//  Created by Ruud Puts on 07/04/15.
//  Copyright (c) 2015 Ruud Puts. All rights reserved.
//

import UIKit

extension UICollectionView {
    
    func dequeueReusableCell(_ cellIdentifier: String!, indexPath: IndexPath!) -> AnyObject {
        return self.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath)
    }
    
}
