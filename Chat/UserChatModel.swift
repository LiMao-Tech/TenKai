//
//  UserChatModel.swift
//  Ten
//
//  Created by gt on 16/1/2.
//  Copyright © 2016年 LiMao Tech. All rights reserved.
//

import UIKit

class UserChatModel: NSObject {
    var userIndex = [Int]() //check if user exist
    dynamic var tenUser = [TenUser]()
    dynamic var message = [Int :[SingleChatMessageFrame]]()
    var msgIndex = 1
    private static var Chats = UserChatModel()
    
    class func allChats() -> UserChatModel{
        return Chats
    }
   
}