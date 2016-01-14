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
    
    class func loadFromNib() -> ChatBaseCell {
        var path : NSString = NSStringFromClass(self.classForCoder())
        path = path.substringFromIndex(4)
        return NSBundle.mainBundle().loadNibNamed("\(path)", owner: self, options: nil).last as! ChatBaseCell
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
