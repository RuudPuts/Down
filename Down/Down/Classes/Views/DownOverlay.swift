//
//  DownOverlay.swift
//  Down
//
//  Created by Ruud Puts on 13/03/17.
//  Copyright © 2017 Ruud Puts. All rights reserved.
//

import UIKit

class DownOverlay: UIView {
    
    private let DefaultTranstionDuration = 0.3
    private var isVisible = false

    @IBOutlet private weak var spinner: DownSpinner!
    @IBOutlet private weak var statusLabel: UILabel!
    @IBOutlet private weak var blurView: UIVisualEffectView!
    
    var status: String? {
        get {
            return statusLabel.text
        }
        set {
            statusLabel.text = newValue
        }
    }
    
    class func overlay() -> DownOverlay {
        let nibView = Bundle.main.loadNibNamed("DownOverlay", owner: self, options: nil)?.first as? UIView
        
        return nibView as? DownOverlay ?? DownOverlay()
    }
    
    class func overlay(withStatus status: String) -> DownOverlay {
        let overlay = DownOverlay.overlay()
        overlay.status = status
        
        return overlay
    }
        
    override func awakeFromNib() {
        backgroundColor = .clear
        blurView.effect = UIBlurEffect(style: .regular)
        alpha = 0.0
    }
    
    func show() {
        transformAlpha(1.0) {
            self.isVisible = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.spinner.startAnimation()
        }
    }
    
    func complete(withResult result: DownSpinner.Result) {
        spinner.endAnimation(withResult: result)
    }
    
    func hide() {
        transformAlpha(0.0) {
            self.isVisible = false
            self.removeFromSuperview()
        }
    }
    
    func transformAlpha(_ alpha: CGFloat, _ completion: (() -> Void)?) {
        UIView.animate(withDuration: DefaultTranstionDuration, animations: { 
            self.alpha = alpha
        }) { completed in
            if let block = completion {
                block()
            }
        }
    }

}
