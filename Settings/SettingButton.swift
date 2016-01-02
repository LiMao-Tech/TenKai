//
//  SettingButton.swift
//  Ten
//
//  Created by gt on 15/10/18.
//  Copyright © 2015年 LiMao Tech. All rights reserved.
//

import UIKit

enum systemType{
    case System, Notification
}

enum chatType{
    case Active, InActive
}

class SettingButton: UIButton {
    var model:pcoinModelType = .Pcoin
    var systemModel:systemType = .System
    var chatModel:chatType = .Active
    var seletedImage:UIImage!
    var normalImage:UIImage!
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
