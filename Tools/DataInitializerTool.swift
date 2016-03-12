//
//  DataInitializerTool.swift
//  Ten
//
//  Created by gt on 16/1/11.
//  Copyright © 2016年 LiMao Tech. All rights reserved.
//

import UIKit

class DataInitializerTool: NSObject {
    class func initialiseInfo() {
        print("msgIndex:")
        print(SHARED_USER.MsgIndex)
        //initialiseUserAndMessages
        let usersInfo = UsersCacheTool().getUserInfo()
        if(!usersInfo.isEmpty){
            SHARED_CHATS.tenUser = usersInfo.users
            for user in usersInfo.users{
                print(user.UserName)
                SHARED_CHATS.unReadMessageAmount[user.UserIndex] = 0
                SHARED_CHATS.userIndex.append(user.UserIndex)
                SHARED_CHATS.tenUsers[user.UserIndex] = user
                UserChatModel.allChats().message[user.UserIndex] = MessageCacheTool(userIndex: user.UserIndex).loadMessage(user.UserIndex, msgIndex:SHARED_USER.MsgIndex+1).messageFrames
            }
        }
        
        //initialise Notification
        let notiInfo = NotificationCacheTool().loadNotification()
        if(!notiInfo.isEmpty){
            SHARED_CHATS.notifications = notiInfo.notis
        }
        //initialise raterIndex
        let rater = UserRaterCache().getUserRaterInfo()
        if(!rater.isEmpty){
            print("raterIndex")
            print(rater.raterIndexs)
            SHARED_CHATS.raterIndex = rater.raterIndexs
            for user in SHARED_CHATS.tenUser{
                if(rater.raterIndexs.contains(user.UserIndex)){
                    user.isRatered = true
                }
            }
        }
        //initialise active & inactive userlist
        if(NSUserDefaults.standardUserDefaults().valueForKey("activeUserIndex") != nil){
            SHARED_CHATS.activeUserIndex = NSUserDefaults.standardUserDefaults().valueForKey("activeUserIndex") as! [Int]
        }
        if(NSUserDefaults.standardUserDefaults().valueForKey("inActiveUserIndex") != nil){
            SHARED_CHATS.inActiveUserIndex = NSUserDefaults.standardUserDefaults().valueForKey("inActiveUserIndex") as! [Int]
        }
        
    }
    
    func deinitialiseInfo(){
       let infos = UserChatModel.allChats()
        infos.tenUser.removeAll()
        infos.notifications.removeAll()
        for index in infos.userIndex{
            infos.message[index]?.removeAll()
        }
        infos.userIndex.removeAll()
        
    }
    
}
