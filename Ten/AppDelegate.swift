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
        print(Url_Home)
        
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
            //datainitialise
            DataInitializerTool.initialiseInfo()
            
            self.window?.rootViewController = nVC
        }else{
            let wVC = WelcomeController()
            self.window?.rootViewController = wVC
        }
        
        UITextField.appearance().tintColor = COLOR_ORANGE
        print(UUID)
        
        //----------------- remote notification started ----------------------//
        print(UIDevice.currentDevice().systemVersion)
        
        switch(getMajorSystemVersion()) {
        case 7:
            let pushSettings: UIUserNotificationSettings = UIUserNotificationSettings(
                forTypes:
                [UIUserNotificationType.Alert, UIUserNotificationType.Badge, UIUserNotificationType.Sound],
                categories: nil)
            UIApplication.sharedApplication().registerUserNotificationSettings(pushSettings)
            UIApplication.sharedApplication().registerForRemoteNotifications()
//            UIApplication.sharedApplication().registerForRemoteNotificationTypes(
//                [UIRemoteNotificationType.Badge, UIRemoteNotificationType.Sound, UIRemoteNotificationType.Alert])
            
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
        print("Token: \(DEVICE_TOKEN!)")
        if(NSUserDefaults.standardUserDefaults().valueForKey("Logined") != nil){
            let url = Url_Api + "TenLogins?userindex=\(SHARED_USER.UserIndex)&devicetoken=\(DEVICE_TOKEN!)"
//            let newUrl = url.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
            let charSet = NSCharacterSet(charactersInString: url)
            let urlNew = url.stringByAddingPercentEncodingWithAllowedCharacters(charSet)
            AFJSONManager.SharedInstance.postMethod(urlNew!, parameters: nil, success: { (task, response) -> Void in
                    print("更新devicetoken成功")
                    print(response)
                }, failure: { (task, error) -> Void in
                    print("更新devicetoken失败")
                    print(error.localizedDescription)
            })
        }
        NSUserDefaults.standardUserDefaults().setValue(DEVICE_TOKEN, forKey: "DeviceToken")
        
        
        // TODO: save this cleanToken into server and to default user data

    }
    
    // Failed to register for Push
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        
        NSLog("Failed to get token; error: %@", error) //Log an error for debugging purposes, user doesn't need to know
    }
    
    // Recive remote notification
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        
        print(userInfo["aps"])
        print("appdelegate in")
        
        RemoteNotificationManager.getInfos()
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
        
        let vc = self.window?.rootViewController
        if(vc!.isKindOfClass(UINavigationController)){
            let nvc = vc as! UINavigationController
            print("root vc visible : \(nvc.visibleViewController)")
            let pvc = PasscodeController()
            pvc.passcodeModel = .Unlock
            nvc.presentViewController(pvc, animated: false, completion: nil)

            
        }
        RemoteNotificationManager.getInfos()
        
        // clear notification badge
        SHARED_APP.applicationIconBadgeNumber = 0

    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        

        print("application Will Terminate")
    }
}

