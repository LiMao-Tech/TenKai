//
//  Notification.swift
//  Ten
//
//  Created by gt on 15/10/12.
//  Copyright © 2015年 LiMao Tech. All rights reserved.
//

import UIKit
enum infoType{
    case SYSTEM,NOTIFICATION
}

class Notification: NSObject {
    var title = "TEN Team"
    var type:infoType = infoType.SYSTEM
    var IsLocked = 0;
    var MsgContent = ""
    var MsgIndex = 0;
    var MsgTime = "2015-12-21T22:11:22.757";
    var MsgType = 0;
    var PhoneType = 0;
    var Receiver = 0;
    var Sender = 0;
    /*
    IsLocked = 0;
    MsgContent = tuantuanpost;
    MsgIndex = 6;
    MsgTime = "2015-12-21T22:11:22.757";
    MsgType = 1;
    PhoneType = 0;
    Receiver = 3;
    Sender = 2;
    */
}
