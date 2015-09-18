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
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController!.setNavigationBarHidden(false, animated: animated)
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController!.setNavigationBarHidden(true, animated: animated)
    }
}