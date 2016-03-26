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

    private var userListLv: [AnyObject]?
    
    override init() {
        super.init()
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
        ALAMO_MANAGER.request(.GET, Url_User, parameters: nil) .responseJSON { response in

            if let values = response.result.value {
                self.userList = (values as? [AnyObject])!
                
                for i in 0..<self.userList.count {
                    let userJSON = JSON(self.userList[i] as! [String: AnyObject])
                    let avg = (userJSON["OuterScore"].intValue + userJSON["InnerScore"].intValue)/2
                    if userJSON["UserIndex"].intValue == SHARED_USER.UserIndex || SHARED_USER.Average < avg {
                        self.userList.removeAtIndex(i)
                        break
                    }
                }
                
                mainVC.userListAlert.dismissViewControllerAnimated(true, completion: nil)
                mainVC.refreshBtnClicked()
            }
        }
    }
}
