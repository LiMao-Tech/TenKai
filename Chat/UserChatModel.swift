//
//  UserChatModel.swift
//  Ten
//
//  Created by gt on 16/1/2.
//  Copyright © 2016年 LiMao Tech. All rights reserved.
//

import UIKit

class UserChatModel: NSObject {
    var raterIndex = [Int]()//本用户评分过的用户的userIndex列表
    var outerRaterIndex = [Int]()
    
    dynamic var activeUserIndex = [Int]()//聊天中的用户的userIndex列表，展示聊天中的用户
    dynamic var inActiveUserIndex = [Int]()//等待中的用户的userIndex列表，展示等待中的用户
    
    var tenUsers = [Int:TenUser]()//以UserIndex为key，TenUser类实例为Value的字典，以UserIndex来查找响应的tenUser
    
    dynamic var notifications = [NotificationFrame]()//用来存储系统和通知的数组，展示系统和通知
    dynamic var message = [Int :[SingleChatMessageFrame]]()//用来存储对应UserIndex的TenUser实例的聊天记录字典，key为UserIndex，value为UserIndex对应的TenUser的一个聊天信息的数组，用来展示聊天信息
    var msgIndex = 1//本机用户的最新消息的Index值，用来读取消息，从网络或从数据库
    
    private static var Chats = UserChatModel()// 本类的一个实例，操作时统一操作这个类，以便数据一致，它的获取方法是 UserChatModel.allChats
    
    class func allChats() -> UserChatModel{
        return Chats
    }
    
    class func removeAll(){
        Chats.notifications = [NotificationFrame]()
        Chats.activeUserIndex = [Int]()
        Chats.inActiveUserIndex = [Int]()
        Chats.raterIndex = [Int]()
        Chats.outerRaterIndex = [Int]()
        Chats.outerRaterIndex = [Int]()
        Chats.message = [Int :[SingleChatMessageFrame]]()
        
    }
   
}
