//
//  String+Extensions.swift
//  Down
//
//  Created by Ruud Puts on 03/07/16.
//  Copyright © 2016 Ruud Puts. All rights reserved.
//

import UIKit

extension String {
    
    func sizeWithFont(_ font: UIFont, width: CGFloat) -> CGSize {
        let size = self.boundingRect(with: CGSize(width: width, height: 2000), options: NSStringDrawingOptions.usesLineFragmentOrigin,
                                             attributes: [NSFontAttributeName: font], context: nil).size as CGSize
        
        return size
    }
}
