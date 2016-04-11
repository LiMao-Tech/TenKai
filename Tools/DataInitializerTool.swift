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
        //face codes
        let faceMap = NSDictionary(contentsOfFile: NSBundle.mainBundle().pathForResource("_expression_en", ofType: "plist")!)!
        for i in 1...faceMap.count{
            let name = NSString(format: "[%03d]", i)
            faceCodes.addObject(name)
        }
        //initialiseUserAndMessages
        let usersInfo = UsersCacheTool().getUserInfo()
        if(!usersInfo.isEmpty){
            for user in usersInfo.users{
                unReadNum += user.badgeNum
                SHARED_CHATS.tenUsers[user.UserIndex] = user
                SHARED_CHATS.message[user.UserIndex] = MessageCacheTool(userIndex: user.UserIndex).loadMessage(user.UserIndex, msgIndex:SHARED_USER.MsgIndex+1).messageFrames
            }
        }
        
        //initialise Notification
        let notiInfo = NotificationCacheTool().loadNotification()
        if(!notiInfo.isEmpty){
            SHARED_CHATS.notifications = notiInfo.notis
        }
        //initialise raterIndex
        let rater = UserRaterCache().getUserRaterInfo(0)
        if(!rater.isEmpty){
            print("raterIndex:")
            print(rater.raterIndexs)
            SHARED_CHATS.raterIndex = rater.raterIndexs
            for user in usersInfo.users{
                if(rater.raterIndexs.contains(user.UserIndex)){
                    user.isRatered = true
                }
            }
        }
        let raterOuter = UserRaterCache().getUserRaterInfo(1)
        if(!raterOuter.isEmpty){
            print("raterOuterIndex:")
            print(raterOuter.raterIndexs)
            SHARED_CHATS.outerRaterIndex = raterOuter.raterIndexs
        }

        //initialise active & inactive userlist
        let listCache = UserListCache()
        if(!listCache.getUserList(0)){
            listCache.addUserList(0)
        }
        if(!listCache.getUserList(1)){
            listCache.addUserList(1)
        }
        
        print("activeUserIndex:")
        print(SHARED_CHATS.activeUserIndex)
        print("inActiveUserIndex:")
        print(SHARED_CHATS.inActiveUserIndex)
        
        
    }
    
}
