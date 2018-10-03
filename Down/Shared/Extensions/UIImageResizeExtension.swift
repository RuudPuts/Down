//
//  UIImageResize.swift
//  Down
//
//  Created by Ruud Puts on 27/08/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import UIKit

extension UIImage {
    func scaled(to newSize: CGSize) -> UIImage {
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
