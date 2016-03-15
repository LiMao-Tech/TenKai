//
//  Notification.swift
//  Ten
//
//  Created by gt on 15/10/12.
//  Copyright © 2015年 LiMao Tech. All rights reserved.
//

import UIKit

class Notification: NSObject {
    
    var title = "TEN Team"
    
    var MsgContent = ""
    var MsgIndex = 0
    var MsgTime:NSTimeInterval = 0
    var MsgType = 0{
        didSet{
            if(MsgType == 3){
                title = "您获得了新的评分"
            }
        }
    }
    var PhoneType = 0
    var Receiver = 0
    var Sender = 0
    var IsLocked = 0
    
    override init() {
        super.init()
    }
    
    init(dict:NSDictionary){
        super.init()
        self.changValue(dict)
    }
    
    func changValue(dict:NSDictionary){
        self.setValuesForKeysWithDictionary(dict as! [String : AnyObject])
    }
}
