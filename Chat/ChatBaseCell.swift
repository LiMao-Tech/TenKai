//
//  ChatBaseCell.swift
//  swiftChat
//
//  Created by gt on 15/9/12.
//  Copyright (c) 2015年 gt. All rights reserved.
//

import UIKit

class ChatBaseCell: UITableViewCell {
    var chatFrame :SingleChatMessageFrame!
    var tenUser:TenUser!
    class func loadFromNib() -> ChatBaseCell {
        var path : NSString = NSStringFromClass(self.classForCoder())
        path = path.substringFromIndex(4)
        return NSBundle.mainBundle().loadNibNamed("\(path)", owner: self, options: nil).last as! ChatBaseCell
    }
}
