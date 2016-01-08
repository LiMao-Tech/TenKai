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
import Alamofire

var DEVICE_TOKEN : String?
let ALAMO_MANAGER = Alamofire.Manager.sharedInstance


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {
    var window: UIWindow?
    
    //var locationManager = SharedLocationManager()
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
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
            sharedManager.locationManager!.requestWhenInUseAuthorization()
        }
        

        print([SCREEN_WIDTH, SCREEN_HEIGHT])
        
//        sharedDatabase.createUserTable()
//        sharedDatabase.insertUser(userIndex: 1, user_id: "exampleid_1", user_name: "Luren0", gender: 0, birth_date: NSDate(), joined_date: NSDate(), last_login_datetime: NSDate(), p_coin: "100.00", outer_score: 10, inner_score: 10, energy: 10, quote: "quote", latitude: 10.12342, longitude: 12.72518)
//          
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
        
        let params = ["receiver":SharedUser.StandardUser().UserIndex,"currIndex":SharedUser.StandardUser().MsgIndex]
        AFNetworkTools.getMethodWithParams(MsgUrl,parameters: params, success: { (task, response) -> Void in
            let userInfoArray = response as! NSArray
            print(userInfoArray)
            for info in userInfoArray{
                let senderIndex = info["Sender"] as! Int
                if(senderIndex == 0){
                    let noti = Notification(dict: info as! NSDictionary)
                    let notiFrame = NotificationFrame()
                    notiFrame.notification = noti
                    //add notification to notifications
                    UserChatModel.allChats().notifications.append(notiFrame)
                    // save to db
                    
                    break
                }
                
                if(UserChatModel.allChats().userIndex.contains(senderIndex)){
                    // add message to the dictionary 
                    let messageFrame = SingleChatMessageFrame()
                    messageFrame.chatMessage = SingleChatMessage(dict: info as! NSDictionary)
                    UserChatModel.allChats().message[senderIndex]!.append(messageFrame)
                }
                else {
                    // add message to the dictionary
                    UserChatModel.allChats().userIndex.append(senderIndex)
                    let messageFrame = SingleChatMessageFrame()
                    messageFrame.chatMessage = SingleChatMessage(dict: info as! NSDictionary)
                    UserChatModel.allChats().message[senderIndex] = [messageFrame]
                    
                    // get userInfo
                    AFNetworkTools.getMethodWithParams(UserUrl, parameters: ["id":senderIndex], success: { (task, response) -> Void in
                        let userDict = response as! NSDictionary
                        let user = TenUser(dict: userDict as! [String : AnyObject])
                        
                        //add to allChats users
                        UserChatModel.allChats().tenUser.append(user)
                        
                        },
                        failure: { (task, error) -> Void in
                            print(error.localizedDescription)
                    })
                    
                    print(UserChatModel.allChats().userIndex)
                }
            }
            SharedUser.StandardUser().MsgIndex = (userInfoArray.lastObject as! NSDictionary)["MsgIndex"] as! Int
            UserCacheTool().upDateUserMsgInde(SharedUser.StandardUser().MsgIndex)
            
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
        print("in Did Enter Background State")
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        print("in Will Enter Foreground State")
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        print("*********** in Did Become Active *************")
        
        // Update Token if has changed
        
        
        
        // clear notification badge
        UIApplication.sharedApplication().applicationIconBadgeNumber = 0
        
        // checking for location Manager's authorization status
        
        if(sharedManager.FIRST_TIME == 0){
            // do nothing
            sharedManager.FIRST_TIME = 1
            print("detected it was the first time the app runs before the determination")
        }
        else if(sharedManager.FIRST_TIME == 1){
            
            let status = CLLocationManager.authorizationStatus()
            print("status is: \(status.rawValue)")
            switch status {
            case .AuthorizedWhenInUse:
                //AUTHORIZATION_STATUS_FLAG = 1 // passed
                //sharedManager.locationManager!.startUpdatingLocation()
                break
                
            case .NotDetermined, .Restricted, .Denied:
                
                print("first time veriable is: \(sharedManager.FIRST_TIME)")
                
                print("<<<< --- in denied case --- >>>>")
                let alertController = UIAlertController(
                    title: "While In Use Location Access Disabled",
                    message: "In order to be notified about nearby cute boys and girls, please enable this service while in use of Ten.",
                    preferredStyle: .Alert)
                
                let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
                alertController.addAction(cancelAction)
                
                let openAction = UIAlertAction(title: "Open Settings", style: .Default) { (action) in
                    if let url = NSURL(string:UIApplicationOpenSettingsURLString) {
                        UIApplication.sharedApplication().openURL(url)
                    }
                }
                alertController.addAction(openAction)
                
                self.window!.rootViewController?.presentViewController(alertController, animated: true, completion: nil)

                // keep authorization status flag to be 0;
                break
                
            default:
                // error state
                //AUTHORIZATION_STATUS_FLAG = -1
                break
            }
        }
        else{
            //error 
            print("error occured on FIRST_TIME variable")
        }
        
        // end of location manager authorization
        
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        
        print("in Will Terminate State, byebye")
    }

}

