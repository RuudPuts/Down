//
//  String+Extensions.swift
//  Down
//
//  Created by Ruud Puts on 03/07/16.
//  Copyright © 2016 Ruud Puts. All rights reserved.
//

import UIKit

extension String {
    
    func sizeWithFont(font: UIFont, width: CGFloat) -> CGSize {
        let size = self.boundingRectWithSize(CGSizeMake(width, 2000), options: NSStringDrawingOptions.UsesLineFragmentOrigin,
                                             attributes: [NSFontAttributeName: font], context: nil).size as CGSize
        
        return size
    }
    
    var trimmed: String {
        return self.stringByTrimmingCharactersInSet(.whitespaceCharacterSet())
    }
}