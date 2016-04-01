//
//  TenOtherUsersJSONManager.swift
//  Ten
//
//  Created by Yumen Cao on 2/6/16.
//  Copyright © 2016 LiMao Tech. All rights reserved.
//

import UIKit
import SwiftyJSON

class TenOtherUsersJSONManager: NSObject {

    
    static let SharedInstance = TenOtherUsersJSONManager()
    
    private let MaxUsersOnGrid = 24
    
    private var userList: [AnyObject] = [AnyObject]()
    
    override init() {
        super.init()
    }
    

    func isUserListEmpty() -> Bool {
        return userList.count == 0
    }

    func selectGridUsers() -> [AnyObject] {
        
        var gridUsers = [AnyObject]()
        
        let count = userList.count < MaxUsersOnGrid ? userList.count : MaxUsersOnGrid
    
        for i in 0..<count {
            gridUsers.append(userList[i])
        }
        return gridUsers
    }

    func selectGridUsersByGender(gender: Int) -> [AnyObject] {

        var gridUsers = [AnyObject]()

        let count = userList.count < MaxUsersOnGrid ? userList.count : MaxUsersOnGrid

        for i in 0..<count {
            let userJSON = JSON(userList[i] as! [String: AnyObject])
            if (userJSON["Gender"].intValue == gender) {
                gridUsers.append(userList[i])
            }
        }
        return gridUsers
    }
    
    func selectLevelUsers(level:Int) -> [AnyObject]{
        var levelUsers = [AnyObject]()
        
        for user in userList{
            let userJSON = user as! [String: AnyObject]
            if(userJSON["AVG"] as! Int == level){
                levelUsers.append(user)
            }
        }
        
        return levelUsers
    }
    
    func selectRandomUsers() -> [TenUser] {
        
        var randomUsers = [TenUser]()
        
        for entity in userList {

            let user = TenUser(dict: entity as! [String : AnyObject])
            randomUsers.append(user)
        }
        
        return randomUsers
    }
    
    func getUserList(mainVC: MainViewController) {
        /* self.refreshBtn.enabled = false
         if TenOtherUsersJSONManager.SharedInstance.isUserListEmpty() {
         self.navigationController?.presentViewController(userListAlert, animated: true, completion: nil)
         TenOtherUsersJSONManager.SharedInstance.getUserList(self)
         }
         
         TenMainGridManager.SharedInstance.clearNodes()
         generateNodes()
         */
        let targetUrl = Url_User + "\(SHARED_USER.UserIndex)?level=\(SHARED_USER.AVG)"
        ALAMO_MANAGER.request(.GET, targetUrl, parameters: nil) .responseJSON { response in

            if let values = response.result.value {
                print("values:")
                print(values)
//                mainVC.userListAlert.dismissViewControllerAnimated(true, completion: nil)
                mainVC.loading.removeFromSuperview()
                if let valuesArray = values as? [AnyObject]{
                    self.userList = valuesArray
                }
//                mainVC.refreshBtnClicked()
                TenMainGridManager.SharedInstance.clearNodes()
                mainVC.generateNodes()
            }
            else {
                mainVC.loading.removeFromSuperview()
                mainVC.userListAlert.title = "加载失败"
                mainVC.userListAlert.message = "请检查网络连接后重试。"
                let cancelAction = UIAlertAction(title: "取消", style: .Cancel, handler: {
                    alert in
                    mainVC.view.addSubview(mainVC.loading)
                })
                if mainVC.userListAlert.actions.count == 0 {
                    mainVC.userListAlert.addAction(cancelAction)
                }
            }
        }
    }
}
