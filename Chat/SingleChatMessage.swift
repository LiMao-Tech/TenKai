//
//  SingleChatMessage.swift
//  swiftChat
//
//  Created by gt on 15/9/12.
//  Copyright (c) 2015年 gt. All rights reserved.
//

import UIKit

enum ChatBelongType:Int {
    case Me
    case Other
}

enum ChatMessageType: Int {
    case Message
    case Image
    case Pcoin
}

class SingleChatMessage: NSObject {
    
    var Sender = 0
    var Receiver = 0
    var MsgIndex = 0
    var MsgTime = ""
    var MsgContent = ""{
        didSet{
            MsgData = MsgContent.dataUsingEncoding(NSUTF8StringEncoding)!
        }
    }
    var MsgType = 0
    var PhoneType = 0
    var isString = true
    var IsLocked = false
    var attrMsg = NSMutableAttributedString()
    var timeHide = false
    var MsgData = NSData()
    var belongType = ChatBelongType.Me
    var messageType = ChatMessageType.Message
    
    override init(){
        super.init()
    }
    
    init(dict :NSDictionary) {
        super.init()
        self.setValuesForKeysWithDictionary(dict as! [String : AnyObject])
    }
}