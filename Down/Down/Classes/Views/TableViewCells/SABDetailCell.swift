//
//  SabNZBdDetailCell.swift
//  Down
//
//  Created by Ruud Puts on 19/07/15.
//  Copyright © 2015 Ruud Puts. All rights reserved.
//

import Foundation

class SABDetailCell: UITableViewCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = UIColor.downLightGreyColor()
        self.textLabel?.textColor = UIColor.downSabNZBdColor()
        self.textLabel?.font = UIFont(name: "OpenSans", size: 14)
        self.detailTextLabel?.textColor = UIColor.whiteColor()
        self.detailTextLabel?.font = UIFont(name: "OpenSans-Light", size: 14)
        self.selectionStyle = .None
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}