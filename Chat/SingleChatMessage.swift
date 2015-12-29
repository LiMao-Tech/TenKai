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
    
    var SenderId = 0
    var receiverId = 0
    var MsgId = 0
    var sendTime = ""
    var Msg = ""
    var isString = true
    var attrMsg = NSMutableAttributedString()
    var nickName : String?
    var timeHide = false
    var belongType = ChatBelongType.Me
    var messageType = ChatMessageType.Message
    
    override init(){
        super.init()
    }
    
    init(dict :NSDictionary){
        super.init()
        self.setValuesForKeysWithDictionary(dict as! [String : AnyObject])
    }
    
}
