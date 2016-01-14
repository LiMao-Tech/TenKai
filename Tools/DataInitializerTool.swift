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
        //initialiseUserAndMessages
        let usersInfo = UsersCacheTool().getUserInfo()
        if(!usersInfo.isEmpty){
            UserChatModel.allChats().tenUser = usersInfo.users
            for user in usersInfo.users{
                print(user.UserName)
                UserChatModel.allChats().userIndex.append(user.UserIndex)
                UserChatModel.allChats().message[user.UserIndex] = MessageCacheTool(userIndex: user.UserIndex).loadMessage(user.UserIndex)
            }
        }
        //initialise Notification
        let notiInfo = NotificationCacheTool().loadNotification()
        if(!notiInfo.isEmpty){
            UserChatModel.allChats().notifications = notiInfo.notis
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
