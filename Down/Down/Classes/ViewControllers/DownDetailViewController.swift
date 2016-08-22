//
//  DownDetailViewController.swift
//  Down
//
//  Created by Ruud Puts on 10/09/15.
//  Copyright © 2015 Ruud Puts. All rights reserved.
//

import UIKit
import DownKit

class DownDetailViewController: DownViewController {
    
    // MARK: Table header view
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if let tableHeaderView = tableView?.tableHeaderView as? UIImageView {
            let imageSize = tableHeaderView.image?.size ?? CGSize(width: 0, height: 0)
            let screenWidth = CGRectGetWidth(view.bounds)
            let ratiodImageHeight = imageSize.height / imageSize.width * screenWidth
            tableHeaderView.frame = CGRectMake(0, 0, screenWidth, ratiodImageHeight)
            
            tableView?.tableHeaderView = tableHeaderView
        }
    }
    
    func setTableViewHeaderImage(image: UIImage?) {
        if image != nil {
            let headerImageView = UIImageView(image: image)
            
            tableView?.tableHeaderView = headerImageView
        }
        else {
            tableView?.tableHeaderView = nil
        }
    }
    
}