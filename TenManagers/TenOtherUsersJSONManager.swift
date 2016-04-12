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
    
    private var userListNearBy: [AnyObject] = [AnyObject]()
    private var userListRandom: [AnyObject] = [AnyObject]()

    override init() {
        super.init()
    }
    

    func isUserListNearByEmpty() -> Bool {
        return userListNearBy.count == 0
    }

    func isUserListEmptyRandom() -> Bool {
        return userListRandom.count == 0
    }

    func selectGridUsers() -> [AnyObject] {
        
        var gridUsers = [AnyObject]()
        
        let count = userListNearBy.count < MaxUsersOnGrid ? userListNearBy.count : MaxUsersOnGrid
    
        for i in 0..<count {
            gridUsers.append(userListNearBy[i])
        }
        return gridUsers
    }

    func selectGridUsersByGender(gender: Int) -> [AnyObject] {

        var gridUsers = [AnyObject]()

        let count = userListNearBy.count < MaxUsersOnGrid ? userListNearBy.count : MaxUsersOnGrid

        for i in 0..<count {
            let userJSON = JSON(userListNearBy[i] as! [String: AnyObject])
            if (userJSON["Gender"].intValue == gender) {
                gridUsers.append(userListNearBy[i])
            }
        }
        return gridUsers
    }
    
    func selectLevelUsers(level: Int) -> [TenUser] {
        
        var levelUsers = [TenUser]()
        
        for entity in userListNearBy {
            let user = TenUser(dict: entity as! [String : AnyObject])

            if user.Average == level {
                levelUsers.append(user)
            }
        }
        
        return levelUsers
    }

    func getUserListNearBy(mainVC: MainViewController) {
        
        print(SHARED_USER.Average)
        print(SHARED_USER.Lati)
        print(SHARED_USER.Longi)
        let targetUrl = Url_User + "?userIndex=\(SHARED_USER.UserIndex)&level=\(SHARED_USER.Average)&mLati=\(SHARED_USER.Lati)&mLongi=\(SHARED_USER.Longi)&range=10000"
        ALAMO_MANAGER.request(.GET, targetUrl, parameters: nil) .responseJSON { response in
            
            if let values = response.result.value {
                mainVC.loading.removeFromSuperview()
                print("user values:")
                print(values)
                if let valuesArray = values as? [AnyObject]{
                    self.userListNearBy = valuesArray
                }
                TenMainGridManager.SharedInstance.clearNodes()
                mainVC.generateNodes()
                mainVC.refreshBtn.enabled = true
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
                mainVC.refreshBtn.enabled = true
            }
        }
    }

    func getUserListRandom(randomVC: RandomUserController, refresh: UIRefreshControl) {
        let targetUrl = Url_User + "?userIndex=\(SHARED_USER.UserIndex)?level=\(SHARED_USER.Average)&random=true"
        ALAMO_MANAGER.request(.GET, targetUrl, parameters: nil) .responseJSON { response in
            randomVC.users.removeAll()
            if let values = response.result.value {
                if let valuesArray = values as? [AnyObject]{

                    self.userListRandom = valuesArray
                    for entity in self.userListRandom {

                        let user = TenUser(dict: entity as! [String : AnyObject])
                        randomVC.users.append(user)
                    }
                    randomVC.userListView.reloadData()
                    refresh.endRefreshing()
                }
            }
        }
    }
}
