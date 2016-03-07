//
//  SettingDoubleLabelCell.swift
//  Ten
//
//  Created by gt on 15/10/15.
//  Copyright © 2015年 LiMao Tech. All rights reserved.
//

import UIKit

class SettingDoubleLabelCell: UITableViewCell {
    var itemLabel:UILabel!
    var versionLabel:UILabel!
    var splitLabel:UIView!
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        itemLabel = UILabel(frame: CGRectMake(0, 30,SCREEN_WIDTH - 60, 15))
        itemLabel.font = UIFont.systemFontOfSize(17)
        itemLabel.textColor = COLOR_FONT_ORANGE
        itemLabel.text = "Version"
        versionLabel = UILabel(frame: CGRectMake(SCREEN_WIDTH - 60 - 50, 30, 50, 15))
        versionLabel.font = UIFont.systemFontOfSize(15)
        versionLabel.textColor = COLOR_FONT_ORANGE
        versionLabel.text = "1.1.14"
        
        splitLabel = UIView(frame: CGRectMake(0, 59, SCREEN_WIDTH - 60, 1))
        splitLabel.backgroundColor = UIColor.whiteColor()
        
        self.addSubview(itemLabel)
        self.addSubview(versionLabel)
        self.addSubview(splitLabel)
        
        self.backgroundColor = UIColor.clearColor()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
