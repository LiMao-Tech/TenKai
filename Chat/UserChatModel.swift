//
//  UserChatModel.swift
//  Ten
//
//  Created by gt on 16/1/2.
//  Copyright © 2016年 LiMao Tech. All rights reserved.
//

import UIKit

class UserChatModel: NSObject {
    var tenUser = TenUser()
    var message = [SingleChatMessageFrame]()
    
    static var AllChats = [UserChatModel]()
    class func allChats() -> [UserChatModel]{
        return AllChats
    }
}
