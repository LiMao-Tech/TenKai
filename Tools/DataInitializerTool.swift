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
                UserChatModel.allChats().unReadMessageAmount[user.UserIndex] = 0
                UserChatModel.allChats().userIndex.append(user.UserIndex)
//                UserChatModel.allChats().message[user.UserIndex] = MessageCacheTool(userIndex: user.UserIndex).loadMessage(user.UserIndex)
                
                UserChatModel.allChats().message[user.UserIndex] = MessageCacheTool(userIndex: user.UserIndex).loadMessage(user.UserIndex, offSet:0)
            }
        }
        
        //initialise Notification
        let notiInfo = NotificationCacheTool().loadNotification()
        if(!notiInfo.isEmpty){
            UserChatModel.allChats().notifications = notiInfo.notis
        }
        //initialise raterIndex
        let rater = UserRaterCache().getUserRaterInfo()
        if(!rater.isEmpty){
            print("raterIndex")
            print(rater.raterIndexs)
            UserChatModel.allChats().raterIndex = rater.raterIndexs
            for user in UserChatModel.allChats().tenUser{
                if(rater.raterIndexs.contains(user.UserIndex)){
                    user.isRatered = true
                }
            }
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
