//
//  SingleChatMessageFrame.swift
//  swiftChat
//
//  Created by gt on 15/9/21.
//  Copyright (c) 2015年 gt. All rights reserved.
//

import UIKit

class SingleChatMessageFrame: NSObject {
    var cellHeight: CGFloat = 0.0
    var contentHeight: CGFloat = 0.0
    var chatMessage = SingleChatMessage(){
        didSet{
            let screen = UIScreen.mainScreen().bounds.size
            if(chatMessage.messageType == ChatMessageType.Message){
                let width = screen.width-130
                let font = UIFont.systemFontOfSize(15)
                let attr = [NSFontAttributeName : font]
                let maxSize:CGSize = CGSizeMake(width,CGFloat(MAXFLOAT))
                if(chatMessage.isString){
                contentHeight = chatMessage.Msg.boundingRectWithSize(maxSize, options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: attr, context: nil).height
                }else{
                contentHeight = chatMessage.attrMsg.boundingRectWithSize(maxSize, options: NSStringDrawingOptions.UsesLineFragmentOrigin, context: nil).height
                }
                cellHeight = contentHeight + 60
            }
            else if(chatMessage.messageType == ChatMessageType.Message){
                
            }
           
        }
    }
    
}
