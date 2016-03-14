//
//  SingleChatMessage.swift
//  swiftChat
//
//  Created by gt on 15/9/12.
//  Copyright (c) 2015年 gt. All rights reserved.
//

import UIKit

enum ChatBelongType:Int {
    case Me = 0,Other
}

enum ChatMessageType: Int {
    case Message = 0,Image,Pcoin
}

class SingleChatMessage: NSObject {
    
    var Sender = 0
    var Receiver = 0{
        didSet{
            if(self.Receiver == SHARED_USER.UserIndex){
                self.belongType = .Other
            }
        }
    }
    var MsgIndex = 0
    var MsgTime:NSTimeInterval = 0
    var MsgContent = ""{
        didSet{
            let stringToAtt = Tools.stringToAttributeString(MsgContent)
            isString = stringToAtt.isString
            attrMsg = stringToAtt.text
        }
    }
    var MsgType = 0{
        didSet{
            messageType = ChatMessageType(rawValue: MsgType)!
        }
    }
    
    var PhoneType = 0
    var IsLocked = false
    
    var isString = true
    var attrMsg = NSMutableAttributedString()
    var timeHide = false
    
    var MsgImage:UIImage?
    var MsgImageSize:CGSize?

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