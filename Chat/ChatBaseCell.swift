//
//  ChatBaseCell.swift
//  swiftChat
//
//  Created by gt on 15/9/12.
//  Copyright (c) 2015年 gt. All rights reserved.
//

import UIKit

protocol ChatBaseCellDelegate:class{
    func unlockBtnClicked(cell:ChatBaseCell)
}
#if DEVELOPMENT
    let index = 8
#else
    let index = 4
#endif

class ChatBaseCell: UITableViewCell {
    var chatFrame :SingleChatMessageFrame!
    var tenUser:TenUser!
    var delegate:ChatBaseCellDelegate?
    
    class func loadFromNib() -> ChatBaseCell {
        var path : NSString = NSStringFromClass(self.classForCoder())
        path = path.substringFromIndex(index)
        return NSBundle.mainBundle().loadNibNamed("\(path)", owner: self, options: nil).last as! ChatBaseCell
    }
}
