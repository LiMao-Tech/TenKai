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
    var raterIndex = [Int]()
    
    var activeUserIndex = [Int]()
    var inActiveUserIndex = [Int]()
    
    var unReadMessageAmount = [Int:Int]()
    
    var tenUsers = [Int:TenUser]()
    
    dynamic var notifications = [NotificationFrame]()
    dynamic var tenUser = [TenUser]()
    dynamic var message = [Int :[SingleChatMessageFrame]]()
    var msgIndex = 1
    private static var Chats = UserChatModel()
    
    class func allChats() -> UserChatModel{
        return Chats
    }
    
    class func removeAll(){
        Chats.message = [Int :[SingleChatMessageFrame]]()
        Chats.userIndex = [Int]() //check if user exist
        Chats.notifications = [NotificationFrame]()
        Chats.tenUser = [TenUser]()
        
    }
   
}
