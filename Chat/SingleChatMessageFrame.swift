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
    
    var chatMessage = SingleChatMessage() {
        didSet{
            let width = SCREEN_WIDTH - 130
            if chatMessage.messageType == ChatMessageType.Message {
                let font = UIFont.systemFontOfSize(15)
                let attr = [NSFontAttributeName : font]
                let maxSize:CGSize = CGSizeMake(width,CGFloat(MAXFLOAT))
                
                if(chatMessage.isString){
                contentHeight = chatMessage.MsgContent.boundingRectWithSize(maxSize, options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: attr, context: nil).height
                }else{
                contentHeight = chatMessage.attrMsg.boundingRectWithSize(maxSize, options: NSStringDrawingOptions.UsesLineFragmentOrigin, context: nil).height
                }
                cellHeight = contentHeight + 60
            }
            else if chatMessage.messageType == ChatMessageType.Image {
                let size = chatMessage.MsgImage!.size
                let ratio = size.height/size.width
                let height = width*ratio
                cellHeight = height + 46
            }else{
                cellHeight = 40
            }
           
        }
    }
    
}
