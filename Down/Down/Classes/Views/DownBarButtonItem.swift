//
//  DownBarButtonItem.swift
//  Down
//
//  Created by Ruud Puts on 13/03/17.
//  Copyright © 2017 Ruud Puts. All rights reserved.
//

import UIKit

class DownBarButtonItem: UIBarButtonItem {

    override init() {
        super.init()
        
        title = " "
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        self.init()
    }
    
    // MARK: Spinner
    
    var isSpinning = false {
        didSet {
            showSpinner(isSpinning)
        }
    }
    
    private func showSpinner(_ show: Bool) {
        if show {
            let spinner = UIActivityIndicatorView(activityIndicatorStyle: .gray)
            spinner.startAnimating()
            customView = spinner
        }
        else {
            customView = nil
        }
        isEnabled = !show
    }
    
    // MARK: Touch closure
    
    var touchClosure: (() -> Void)? {
        didSet {
            if touchClosure == nil {
                target = nil
                action = nil
            }
            else {
                target = self
                action = #selector(buttonTapped)
            }
        }
    }
    
    @objc func buttonTapped() {
        guard let closure = touchClosure else {
            return
        }
        
        closure()
    }
    
}
