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
    
    private let MaxUsersOnGrid = 10
    
    private var userList: [AnyObject] = [AnyObject]()
    
    override init() {
        super.init()
    
        getUserList()
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
    
    func selectRandomUsers() -> [AnyObject] {
        
        var randomUsers = [AnyObject]()
        
        for user in userList {
            
            randomUsers.append(user)
        }
        
        return randomUsers
    }
    
    private func getUserList() -> Void {
        ALAMO_MANAGER.request(.GET, Url_User, parameters: nil) .responseJSON { response in
            if let values = response.result.value {
                self.userList = (values as? [AnyObject])!
                
                for i in 0..<self.userList.count {
                    let userJSON = JSON(self.userList[i] as! [String: AnyObject])
                    if userJSON["UserIndex"].intValue == SHARED_USER.UserIndex {
                        self.userList.removeAtIndex(i)
                        break
                    }
                }
            }
        }
    }
}
