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

let HomeUrl = "http://www.limao-tech.com/Ten/"

let ApiUrl = HomeUrl + "api/"
let LoginUrl = ApiUrl + "TenLogins"
let UserUrl = ApiUrl + "TenUsers"
let MsgUrl = ApiUrl + "TenMsgs"
let PCoinUrl = ApiUrl + "PCoinTrans/"
let RaterUrl = ApiUrl + "Rater/"

let ImagesJSONUrl = HomeUrl + "TenImage/GetImagesByUser?id="
let ImageUrl = HomeUrl + "TenImage?id="

let HeadImageGetUrl = HomeUrl + "TenImage/GetProfileByUser?userIndex="
let HeadImageUploadUrl = HomeUrl + "TenImage/UploadProfileImage/"
let PhotosUrl = HomeUrl + "TenImage/UploadPhotos/"
let getPortraitUrl = HomeUrl + "TenImage?id="

let DeviceTokenUrl = ""

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

//Colors
let COLOR_BG = UIColor(red: 29.0/255.0, green: 29.0/255.0, blue: 29.0/255.0, alpha: 1.0)
let COLOR_NAV_BAR = UIColor(red: 25.0/255.0, green: 25.0/255.0, blue: 25.0/255.0, alpha: 1.0)
let COLOR_ORANGE = UIColor(red: 255.0/255.0, green: 90.0/255.0, blue: 85.0/255.0, alpha: 1.0) //ff5a55
let COLOR_WHITEGRAY = UIColor(red: 95.0/255.0, green: 95.0/255.0, blue: 95.0/255.0, alpha: 1.0)

// Profile Pics

let BLOCK_DIM = SCREEN_WIDTH/4

// gener colors

let COLOR_MALE = UIColor(red: 46/255.0, green: 158/255.0, blue: 207/255.0, alpha: 1.0)
let COLOR_FEMALE = UIColor(red: 231/255.0, green: 71/255.0, blue: 128/255.0, alpha: 1.0)

// level colors
let COLOR_LEVEL_1 = UIColor(red: 148/255.0, green: 149/255.0, blue: 151/255.0, alpha: 1.0)
let COLOR_LEVEL_2 = UIColor(red: 33/255.0, green: 192/255.0, blue: 245/255.0, alpha: 1.0)
let COLOR_LEVEL_3 = UIColor(red: 253/255.0, green: 213/255.0, blue: 92/255.0, alpha: 1.0)
let COLOR_LEVEL_4 = UIColor(red: 244/255.0, green: 139/255.0, blue: 57/255.0, alpha: 1.0)
let COLOR_LEVEL_5 = UIColor(red: 94/255.0, green: 126/255.0, blue: 212/255.0, alpha: 1.0)
let COLOR_LEVEL_6 = UIColor(red: 47/255.0, green: 194/255.0, blue: 143/255.0, alpha: 1.0)
let COLOR_LEVEL_7 = UIColor(red: 95/255.0, green: 194/255.0, blue: 181/255.0, alpha: 1.0)
let COLOR_LEVEL_8 = UIColor(red: 144/255.0, green: 52/255.0, blue: 154/255.0, alpha: 1.0)
let COLOR_LEVEL_9 = UIColor(red: 227/255.0, green: 84/255.0, blue: 157/255.0, alpha: 1.0)
let COLOR_LEVEL_10 = UIColor(red: 75/255.0, green: 143/255.0, blue: 202/255.0, alpha: 1.0)

let LEVEL_COLORS = [COLOR_LEVEL_1, COLOR_LEVEL_2, COLOR_LEVEL_3, COLOR_LEVEL_4, COLOR_LEVEL_5, COLOR_LEVEL_6, COLOR_LEVEL_7, COLOR_LEVEL_8, COLOR_LEVEL_9, COLOR_LEVEL_10]
