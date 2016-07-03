//
//  DownRootViewController.swift
//  Down
//
//  Created by Ruud Puts on 03/07/16.
//  Copyright © 2016 Ruud Puts. All rights reserved.
//

class DownRootViewController: DownViewController {
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        hideNavigationBar(animated)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        showNavigationBar(animated)
    }
    
    // MARK: Navigation bar
    
    func showNavigationBar(animated: Bool) {
        guard self.navigationController?.viewControllers.count == 2 else {
            return
        }
        
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    func hideNavigationBar(animated: Bool) {
        guard self.navigationController?.viewControllers.count == 1 else {
            return
        }
        
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
}
