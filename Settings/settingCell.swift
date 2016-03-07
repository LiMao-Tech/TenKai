//
//  settingCell.swift
//  Ten
//
//  Created by gt on 15/10/12.
//  Copyright © 2015年 LiMao Tech. All rights reserved.
//

import UIKit

class settingCell: UITableViewCell {
    var itemLabel:UILabel!
    var accessoryItem:UIImage!
    var splitLine:UIView!

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        itemLabel = UILabel(frame: CGRectMake(0, 10, self.bounds.width, 20))
        itemLabel.textColor = COLOR_FONT_ORANGE
        itemLabel.font = UIFont.systemFontOfSize(17)
        
        
        splitLine = UIView(frame: CGRectMake(0, 39, self.bounds.width, 1))
        splitLine.backgroundColor = UIColor.whiteColor()
        
        self.addSubview(itemLabel)
        self.addSubview(splitLine)
        self.backgroundColor = UIColor.clearColor()
        self.accessoryType = .DisclosureIndicator
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
