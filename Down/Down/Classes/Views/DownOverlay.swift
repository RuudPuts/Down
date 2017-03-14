//
//  DownOverlay.swift
//  Down
//
//  Created by Ruud Puts on 13/03/17.
//  Copyright © 2017 Ruud Puts. All rights reserved.
//

import UIKit

class DownOverlay: UIVisualEffectView {
    
    let DefaultTranstionDuration = 0.3
    var isVisible = false

    init() {
        super.init(effect: UIBlurEffect(style: .regular))
        alpha = 0.0
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func show() {
        transformAlpha(1.0) {
            self.isVisible = true
        }
    }
    
    func hide() {
        transformAlpha(0.0) {
            self.isVisible = false
            self.removeFromSuperview()
        }
    }
    
    func transformAlpha(_ alpha: CGFloat, _ completion: ((Void) -> (Void))?) {
        UIView.animate(withDuration: DefaultTranstionDuration, animations: { 
            self.alpha = alpha
        }) { completed in
            if let block = completion {
                block()
            }
        }
    }

}
