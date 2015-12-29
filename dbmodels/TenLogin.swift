//
//  TenLogin.swift
//  Ten
//
//  Created by Yumen Cao on 11/1/15.
//  Copyright © 2015 LiMao Tech. All rights reserved.
//  Heavily Modified by Yumen Tsao on 11/01/15.


/*
Note: This model follows c sharp naming convention since is used with ASP .Net
Backend.

*/


class TenLogin : NSObject {
    
    var LoginIndex : Int = 0
    var UserIndex : Int = 0
    var UserID : String = ""
    var UserPWD : String = ""
    var LastLogin : String = ""
    var DeviceUUID : String = ""    // 16 bytes == 128 bits
    var DeviceToken : String = ""  // 64 bytes
    var HashValue : String = ""     // 64 bytes

    init(loginDict:[String : AnyObject]){
        super.init()
        self.setValuesForKeysWithDictionary(loginDict)
    }
}
