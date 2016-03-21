//
//  RemoteNotificationManager.swift
//  Ten
//
//  Created by gt on 16/3/21.
//  Copyright © 2016年 LiMao Tech. All rights reserved.
//

import UIKit

class RemoteNotificationManager: NSObject {
    class func getInfos(){
        //notification
        let notiParams = ["receiver":0,"currIndex":SHARED_USER.MsgIndex]
        AFJSONManager.SharedInstance.getMethodWithParams(Url_Msg, parameters: notiParams, success: { (task, response) -> Void in
            print("get notification response:")
            print(response)
            let userInfoArray = response as! NSArray
            if userInfoArray.count == 0{
                return
            }
            for info in userInfoArray{
                let noti = Notification(dict: info as! NSDictionary)
                let notiFrame = NotificationFrame()
                notiFrame.notification = noti
                //add notification to notifications
                SHARED_CHATS.notifications.append(notiFrame)
                SHARED_USER.MsgIndex = noti.MsgIndex
                // save to db
                UserCacheTool().upDateUserMsgIndex()
                NotificationCacheTool().addNotificationInfo(noti)
            }
            },failure: { (task, error) -> Void in
                print("get notification failed")
                print(error.localizedDescription)
        })
        
        //msg
        let msgParams = ["receiver": SHARED_USER.UserIndex, "currIndex": SHARED_USER.MsgIndex]
        AFJSONManager.SharedInstance.getMethodWithParams(Url_Msg,parameters: msgParams, success: { (task, response) -> Void in
            let userInfoArray = response as! NSArray
            if userInfoArray.count == 0{
                return
            }
            print("get msg array:")
            print(userInfoArray)
            for info in userInfoArray{
                let senderIndex = info["Sender"] as! Int
//                print("senderIndex:\(senderIndex)")
                //notification
                if(senderIndex == 0){
                    let noti = Notification(dict: info as! NSDictionary)
                    let notiFrame = NotificationFrame()
                    notiFrame.notification = noti
                    //add notification to notifications
                    SHARED_CHATS.notifications.append(notiFrame)
                    // save to db
                    NotificationCacheTool().addNotificationInfo(noti)
                    continue
                }
                //if user not exist get userInfo
                if(SHARED_CHATS.tenUsers[senderIndex] == nil){
                    print("get chat user")
                    SHARED_CHATS.tenUsers[senderIndex] = TenUser()
                    SHARED_CHATS.message[senderIndex] = [SingleChatMessageFrame]()
                    // get userInfo
                    AFJSONManager.SharedInstance.getMethodWithParams(Url_User, parameters: ["id":senderIndex], success: { (task, response) -> Void in
                        print("appdelegate get User:")
                        print(response)
                        let userDict = response as! NSDictionary
                        SHARED_CHATS.tenUsers[senderIndex]?.ValueWithDict(userDict as! [String : AnyObject])
                        UsersCacheTool().addUserInfoByUser(SHARED_CHATS.tenUsers[senderIndex]!)
                        SHARED_CHATS.inActiveUserIndex.insert(senderIndex, atIndex: 0)
                        UserListCache().updateUserList()
                        
                        //get tenUser portrait
                        ALAMO_MANAGER.request(.GET, SHARED_CHATS.tenUsers[senderIndex]!.ProfileUrl) .responseImage { response in
                            if let image = response.result.value {
                                SHARED_CHATS.tenUsers[senderIndex]!.Portrait = UIImagePNGRepresentation(image)
                                UsersCacheTool().upDateUsersPortrait(SHARED_CHATS.tenUsers[senderIndex]!.UserIndex, portrait: image)
                            }
                            else {
                                print("get \(SHARED_CHATS.tenUsers[senderIndex]!.UserName) portrait failed")
                                print(response.result.error?.localizedDescription)
                            }
                        }
                        },
                        failure: { (task, error) -> Void in
                            print("appdelegate tenUser failed")
                            print(error.localizedDescription)
                    })
                }
                
                if(senderIndex != comunicatingIndex){
                    unReadNum += 1
                    SHARED_CHATS.tenUsers[senderIndex]?.badgeNum += 1
                    UsersCacheTool().updateUsersBadgeNum(senderIndex, badgeNum: (SHARED_CHATS.tenUsers[senderIndex]?.badgeNum)!)
                }
                
                //bring the user to the first
                if(SHARED_CHATS.activeUserIndex.contains(senderIndex)){
                    let index = UserChatModel.allChats().activeUserIndex.indexOf(senderIndex)
                    SHARED_CHATS.activeUserIndex.removeAtIndex(index!)
                    SHARED_CHATS.activeUserIndex.insert(senderIndex, atIndex: 0)
                }else if(UserChatModel.allChats().inActiveUserIndex.contains(senderIndex)){
                    let index = UserChatModel.allChats().inActiveUserIndex.indexOf(senderIndex)
                    SHARED_CHATS.inActiveUserIndex.removeAtIndex(index!)
                    SHARED_CHATS.inActiveUserIndex.insert(senderIndex, atIndex: 0)
                }
                UserListCache().updateUserList()
                
                let messageFrame = SingleChatMessageFrame()
                let msgType = info["MsgType"] as! Int
                
                if msgType == 0 {
                    messageFrame.chatMessage = SingleChatMessage(dict: info as! NSDictionary)
                    SHARED_CHATS.message[senderIndex]?.append(messageFrame)
                    MessageCacheTool(userIndex: senderIndex).addMessageInfo(senderIndex, msg: messageFrame.chatMessage)
                }
                else if msgType == 1 {
                    let tempMessage = SingleChatMessage(dict: info as! NSDictionary)
                    
                    ALAMO_MANAGER.request(.GET, tempMessage.MsgContent) .responseImage { response in
                        if let image = response.result.value {
                            tempMessage.MsgImage = image
                            messageFrame.chatMessage = tempMessage
                            SHARED_CHATS.message[senderIndex]?.append(messageFrame)
                            MessageCacheTool(userIndex: senderIndex).addMessageInfo(senderIndex, msg: messageFrame.chatMessage)
                        }
                        else {
                            print(response.result.error?.localizedDescription)
                        }
                    }
                }
                else {
                    print("pcoin message get")
                    messageFrame.chatMessage = SingleChatMessage(dict: info as! NSDictionary)
                    SHARED_USER.PCoin += Double(messageFrame.chatMessage.MsgContent)!
                    UserCacheTool().upDateUserPCoin()
                    SHARED_CHATS.message[senderIndex]?.append(messageFrame)
                    MessageCacheTool(userIndex: senderIndex).addMessageInfo(senderIndex, msg: messageFrame.chatMessage)
                }
            }
            
            let msgIndex = (userInfoArray.lastObject as! NSDictionary)["MsgIndex"] as! Int
            SHARED_USER.MsgIndex = msgIndex
            UserCacheTool().upDateUserMsgIndex()
            
            },failure:  { (task, error) -> Void in
                print("get msg failed:")
                print(error.localizedDescription)
        })

    }
}
