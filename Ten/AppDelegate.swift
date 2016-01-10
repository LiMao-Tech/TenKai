//
//  AppDelegate.swift
//  Ten
//
//  Created by Yumen Cao on 8/22/15.
//  Copyright (c) 2015 LiMao Tech. All rights reserved.
//

import UIKit
import Tweaks
import PureLayout
import CoreLocation
import Foundation


var DEVICE_TOKEN : String?



@UIApplicationMain
class AppDelegate: UIResponder,
                    UIApplicationDelegate,
                    CLLocationManagerDelegate {
    
    var window: UIWindow?
    
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        // TODO: Update Token if has changed
        
        // set Managers delegate
        LOC_MANAGER.delegate = self
        LOC_MANAGER.desiredAccuracy = kCLLocationAccuracyBest
        LOC_MANAGER.distanceFilter = DISTANCE_FILTER
        
        //remember User
        let userIndex = NSUserDefaults.standardUserDefaults().valueForKey("Logined") as? Int
        if userIndex != nil {
            let storyBoard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
            let nVC = storyBoard.instantiateViewControllerWithIdentifier("NavController") as! UINavigationController
            UserCacheTool().getUserInfo(userIndex!)
            self.window?.rootViewController = nVC
        }
        
        UITextField.appearance().tintColor = ORANGE_COLOR
        print(UUID)
        
        //----------------- remote notification started ----------------------//
        print(UIDevice.currentDevice().systemVersion)
        
        switch(getMajorSystemVersion()) {
        case 7:
            UIApplication.sharedApplication().registerForRemoteNotificationTypes(
                [UIRemoteNotificationType.Badge, UIRemoteNotificationType.Sound, UIRemoteNotificationType.Alert])
            
        case 8:
            let pushSettings: UIUserNotificationSettings = UIUserNotificationSettings(
                forTypes:
                [UIUserNotificationType.Alert, UIUserNotificationType.Badge, UIUserNotificationType.Sound],
                categories: nil)
            UIApplication.sharedApplication().registerUserNotificationSettings(pushSettings)
            UIApplication.sharedApplication().registerForRemoteNotifications()
            
        case 9:
            let pushSettings: UIUserNotificationSettings = UIUserNotificationSettings(
                forTypes:
                [UIUserNotificationType.Alert, UIUserNotificationType.Badge, UIUserNotificationType.Sound],
                categories: nil)
            UIApplication.sharedApplication().registerUserNotificationSettings(pushSettings)
            UIApplication.sharedApplication().registerForRemoteNotifications()
        default: return true
        }
        // ---------------------------- END for remote notification -----------------------------//
        
        // Shake to open tweaks menu
        if let rootViewController = window?.rootViewController {
            window = FBTweakShakeWindow(frame: UIScreen.mainScreen().bounds)
            window!.rootViewController = rootViewController
        }
        
        if CLLocationManager.authorizationStatus() == .NotDetermined {
            LOC_MANAGER.requestWhenInUseAuthorization()
        }
        
        print([SCREEN_WIDTH, SCREEN_HEIGHT])
    
        return true
    }
    
    // ---------------------------- for remote notification -----------------------------//
    
    func getMajorSystemVersion() -> Int {
        return Int(String(Array(UIDevice.currentDevice().systemVersion.characters)[0]))!
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        
        let trimEnds = deviceToken.description.stringByTrimmingCharactersInSet(NSCharacterSet(charactersInString: "<>"))
        DEVICE_TOKEN = trimEnds.stringByReplacingOccurrencesOfString(" ", withString: "", options: [])
        
        //Put DeviceToken
        if(NSUserDefaults.standardUserDefaults().valueForKey("Logined") != nil){
            //put deviceTokenByUserIndex
            let userIndex = NSUserDefaults.standardUserDefaults().valueForKey("Logined") as! Int
            
//            let params = ["userindex":userIndex,"devicetoken":DEVICE_TOKEN!]
//            AFNetworkTools.postMethod(LoginUrl, parameters: params as! [String : AnyObject], success: { (task, response) -> Void in
//                print("success")
//                }, failure: { (task, error) -> Void in
//                    print("DeviceToken put failed")
//                    print(error.localizedDescription)
//            })
        }
        print("Token: \(DEVICE_TOKEN!)")
        
        // TODO: save this cleanToken into server and to default user data

    }
    
    // Failed to register for Push
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        
        NSLog("Failed to get token; error: %@", error) //Log an error for debugging purposes, user doesn't need to know
    }
    
    // Recive remote notification
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        
        let params = ["receiver": SHARED_USER.UserIndex, "currIndex": SHARED_USER.MsgIndex]
        AFNetworkTools.getMethodWithParams(MsgUrl,parameters: params, success: { (task, response) -> Void in
            let userInfoArray = response as! NSArray
            print(userInfoArray)
            for info in userInfoArray{
                let senderIndex = info["Sender"] as! Int
                //notification
                if(senderIndex == 0){
                    let noti = Notification(dict: info as! NSDictionary)
                    let notiFrame = NotificationFrame()
                    notiFrame.notification = noti
                    //add notification to notifications
                    UserChatModel.allChats().notifications.append(notiFrame)
                    // save to db
                    
                    break
                }
                let messageFrame = SingleChatMessageFrame()
                if(info["MsgType"] as! Int != 1){
                    messageFrame.chatMessage = SingleChatMessage(dict: info as! NSDictionary)
                }else{
                    let tempMessage = SingleChatMessage(dict: info as! NSDictionary)
                    AFNetworkTools.getImageMethod(messageFrame.chatMessage.MsgContent, success: { (task, response) -> Void in
                        if(UserChatModel.allChats().message[senderIndex] != nil){
                            tempMessage.MsgImage = response as? UIImage
                            messageFrame.chatMessage = tempMessage
                            UserChatModel.allChats().message[senderIndex]?.append(messageFrame)
                            MessageCacheTool(userIndex: senderIndex).addMessageInfo(senderIndex, msg: messageFrame.chatMessage)
                        }
                        UserChatModel.allChats().message[senderIndex]?.append(messageFrame)
                        }, failure: { (task, error) -> Void in
                            
                    })
                }

                if(!UserChatModel.allChats().userIndex.contains(senderIndex)){
                    UserChatModel.allChats().userIndex.append(senderIndex)
                    UserChatModel.allChats().message[senderIndex] = [SingleChatMessageFrame]()
                    
                    // get userInfo
                    AFNetworkTools.getMethodWithParams(UserUrl, parameters: ["id":senderIndex], success: { (task, response) -> Void in
                        let userDict = response as! NSDictionary
                        let user = TenUser(dict: userDict as! [String : AnyObject])
                        //add to allChats users
                        UserChatModel.allChats().tenUser.append(user)
                        },
                        failure: { (task, error) -> Void in
                            print(error.localizedDescription)
                            let index = UserChatModel.allChats().userIndex.indexOf(senderIndex)
                            UserChatModel.allChats().userIndex.removeAtIndex(index!)
                    })
                    print("UserIndex: \(UserChatModel.allChats().userIndex)")
                }
                
                if(messageFrame.chatMessage.messageType != .Image){
                    UserChatModel.allChats().message[senderIndex]?.append(messageFrame)
                    MessageCacheTool(userIndex: senderIndex).addMessageInfo(senderIndex, msg: messageFrame.chatMessage)
                }
            }
            let msgIndex = (userInfoArray.lastObject as! NSDictionary)["MsgIndex"] as! Int
            SHARED_USER.MsgIndex = msgIndex
            UserCacheTool().upDateUserMsgInde(SHARED_USER.MsgIndex)
            
            },failure:  { (task, error) -> Void in
              print(error.localizedDescription)
        })
        /*
            nofiticationtype : notification? message(message,image,pcoin)? pcoin? or?
            message:need UserIndex, messagetype, and Content
        */
        print(userInfo["aps"])
        
    }
    
    // ---------------------------- END for remote notification -----------------------------//

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
        print("in Will Resign Active")
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        LOC_MANAGER.stopUpdatingLocation()
        
        print("in Did Enter Background State")
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        LOC_MANAGER.startUpdatingLocation()
        
        print("in Will Enter Foreground State")
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        print("*********** in Did Become Active *************")
        
        // clear notification badge
        SHARED_APP.applicationIconBadgeNumber = 0

    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        
        print("application Will Terminate")
    }
    
    // Location Manager
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // Post Location to Server
        if let loc = locations.last {
        let params = [
            "UserIndex": SHARED_USER.UserIndex,
            "UserName" : SHARED_USER.UserName,
            "PhoneType" : SHARED_USER.PhoneType,
            "Gender" : SHARED_USER.Gender,
            "Marrige" : SHARED_USER.Marriage,
            "Birthday" : SHARED_USER.Birthday,
            "JoinedDate" : SHARED_USER.JoinedDate,
            "PCoin" : SHARED_USER.PCoin,
            "OuterScore" : SHARED_USER.OuterScore,
            "InnerScore" : SHARED_USER.InnerScore,
            "Energy" : SHARED_USER.Energy,
            "Hobby" : SHARED_USER.Hobby,
            "Quote" : SHARED_USER.Quote,
            "Lati" : loc.coordinate.latitude,
            "Longi" : loc.coordinate.longitude
        ]
        
        let targetUrl = UserUrl+String(SHARED_USER.UserIndex)
         
            ALAMO_MANAGER.request(.PUT, targetUrl, parameters: params as? [String : AnyObject], encoding: .JSON) .responseJSON
                {
                    response in
                    print(response.result.debugDescription)
                }
        
        }

    }
    

}

