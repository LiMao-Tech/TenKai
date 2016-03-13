//
//  UserChatModel.swift
//  Ten
//
//  Created by gt on 16/1/2.
//  Copyright © 2016年 LiMao Tech. All rights reserved.
//

import UIKit

class UserChatModel: NSObject {
    var raterIndex = [Int]()
    
    var activeUserIndex = [Int]()
    var inActiveUserIndex = [Int]()
    
    var tenUsers = [Int:TenUser]()
    
    dynamic var notifications = [NotificationFrame]()
    dynamic var message = [Int :[SingleChatMessageFrame]]()
    var msgIndex = 1
    private static var Chats = UserChatModel()
    
    class func allChats() -> UserChatModel{
        return Chats
    }
    
    class func removeAll(){
        Chats.message = [Int :[SingleChatMessageFrame]]()
        Chats.notifications = [NotificationFrame]()
        Chats.tenUsers = [Int:TenUser]()
        Chats.activeUserIndex = [Int]()
        Chats.inActiveUserIndex = [Int]()
        Chats.raterIndex = [Int]()
    }
   
}
