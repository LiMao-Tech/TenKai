//
//  Common.swift
//  Ten
//
//  Created by gt on 15/11/28.
//  Copyright © 2015年 LiMao Tech. All rights reserved.
//

import UIKit

// Debug printing

/*
print("request: \(response.request)")  // original URL request
print("response: \(response.response)") // URL response
print("data: \(response.data)")     // server data
print("result: \(response.result)")   // result of response serialization
*/



// Location Mangager
let DISTANCE_FILTER: Double = 100 // CLLocationDistance

// urls
let LocationNotiName = "LocationNotification"


let MinBarValue : Float = 0
let MaxBarValue : Float = 10


// screenFrame
let SCREEN = UIScreen.mainScreen().bounds
let SCREEN_HEIGHT = SCREEN.height
let SCREEN_WIDTH = SCREEN.width

// uiFrames
let BUTTON_DENO : CGFloat = 15
let NAV_BAR_HEIGHT : CGFloat = SCREEN_HEIGHT == 568 ? 44 : 66
let TOOL_BAR_HEIGHT : CGFloat = SCREEN_HEIGHT == 568 ? 48 : 73
//let TAP_BAR_HEIGHT : CGFloat = SCREEN_HEIGHT == 568 ? 44 : 52
let TAP_BAR_HEIGHT : CGFloat = SCREEN_HEIGHT*44/568

let SCREEN_HEIGHT_WO_NAV = SCREEN_HEIGHT - NAV_BAR_HEIGHT


let PROFILE_FONT_SIZE : CGFloat = 12
let USERNAME_FONT_SIZE : CGFloat = 26
//font
let FONTNAME_BOLD = "PTSans-Bold"
let FONTNAME_NORMAL = "PTSans"

//netParameters
let UUID = NSUUID().UUIDString

let COMPANYCODE = "e40cb24cffee7767d8f3bd9faf882af614b9e4bd402dc53a70f4723cde991734"

//Strings
let ChatTitle = "聊天"
let ProfileTitle = "首页"
let SettingTitle = "设定"
let PcoinTitle = "P Coin"
let NotificationTitle = "通知"
let RandomTitle = "随机用户"


