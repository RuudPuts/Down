//
//  UIImage+Extensions.swift
//  Down
//
//  Created by Ruud Puts on 03/07/16.
//  Copyright © 2016 Ruud Puts. All rights reserved.
//

import UIKit

extension UIImage {
    
    func resize(_ newSize: CGSize) -> UIImage {
        guard newSize.height > 0 && newSize.width > 0 else {
            return self
        }
        
        let scale = min(newSize.width / size.width, newSize.height / size.height)
        
        return resize(scale: scale)
    }
    
    func resize(scale: CGFloat) -> UIImage {
        let scaleTransform = size.applying(CGAffineTransform(scaleX: scale, y: scale))
        let scaledSize = CGSize(width: size.width * scale, height: size.height * scale)
        
        UIGraphicsBeginImageContextWithOptions(scaleTransform, true, UIScreen.main.scale)
        draw(in: CGRect(origin: CGPoint.zero, size: scaledSize))
        
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return resizedImage!
    }
}
