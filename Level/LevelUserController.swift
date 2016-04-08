//
//  LevelUserController.swift
//  Ten
//
//  Created by gt on 15/10/12.
//  Copyright © 2015年 LiMao Tech. All rights reserved.
//

import UIKit
import SwiftyJSON

class LevelUserController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    var userList:UITableView!
    var level = 0
    var usersList = [TenUser]()
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        refreshControl()
                // Do any additionalsetup after loading the view.
    }
    override func viewWillAppear(animated: Bool) {
        let users = TenOtherUsersJSONManager.SharedInstance.selectLevelUsers(level)
        for userinfo in users{
            let userDict = userinfo as! [String:AnyObject]
            let user = TenUser(dict: userDict)
            usersList.append(user)
        }
        self.userList.reloadData()
    }
    
    func setup(){
        self.title = "等级\(level)"
        userList = UITableView(frame: CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT))
        userList.dataSource = self
        userList.delegate = self
        userList.separatorStyle = .None
        userList.backgroundColor = COLOR_BG
        self.view.addSubview(userList)

    }
    func refreshControl(){
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(LevelUserController.refreshStateChange(_:)), forControlEvents: .ValueChanged)
        
        self.userList.addSubview(refresh)
    }
    
    func refreshStateChange(refresh:UIRefreshControl){
        let users = TenOtherUsersJSONManager.SharedInstance.selectLevelUsers(level)
        for userinfo in users{
            let userDict = userinfo as! [String:AnyObject]
            let user = TenUser(dict: userDict)
            usersList.append(user)
        }
        self.userList.reloadData()
        refresh.endRefreshing()
        print("refreshed")
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usersList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = userList.dequeueReusableCellWithIdentifier("RALUserCell") as? RandomAndLevelUserCell
        if(cell == nil){
            cell = RandomAndLevelUserCell.init(style: UITableViewCellStyle.Default, reuseIdentifier: "RALUserCell")
        }
        let user = usersList[indexPath.row]
        if(user.PortraitImage == nil){
            let imageIndex = user.UserIndex
            let targetUrl = Url_GetHeadImage + String(imageIndex)
            ALAMO_MANAGER.request(.GET, targetUrl)
                .responseImage { response in
                    if let image = response.result.value {
                        user.Portrait = UIImagePNGRepresentation(image)
                        self.userList.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .None)
                    }
            }

        }
        cell?.user = user
        
        return cell!

    }
}
