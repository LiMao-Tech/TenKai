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
    var usersTV: UITableView!
    var level = 0
    var userList = [TenUser]()
    let refresh = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        refreshControl()
        refresh.tintColor = UIColor.whiteColor()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBar.hidden = false
        refresh.beginRefreshing()
    }
    
    override func viewDidAppear(animated: Bool) {
        userList = TenOtherUsersJSONManager.SharedInstance.selectLevelUsers(self, level: level)
        self.usersTV.reloadData()
        refresh.endRefreshing()
    }
    
    func setup(){
        self.title = "等级\(level)"
        usersTV = UITableView(frame: CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT))
        usersTV.dataSource = self
        usersTV.delegate = self
        usersTV.separatorStyle = .None
        usersTV.backgroundColor = COLOR_BG
        self.view.addSubview(usersTV)

    }
    func refreshControl(){
        refresh.addTarget(self, action: #selector(LevelUserController.refreshStateChange(_:)), forControlEvents: .ValueChanged)
        self.usersTV.addSubview(refresh)
    }
    
    func refreshStateChange(refresh:UIRefreshControl){
        userList.removeAll()
        userList = TenOtherUsersJSONManager.SharedInstance.selectLevelUsers(self, level: level)
        self.usersTV.reloadData()
        refresh.endRefreshing()
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = usersTV.dequeueReusableCellWithIdentifier("RALUserCell") as? RandomAndLevelUserCell
        if(cell == nil){
            cell = RandomAndLevelUserCell.init(style: UITableViewCellStyle.Default, reuseIdentifier: "RALUserCell")
        }
        let user = userList[indexPath.row]
    
        cell?.user = user
        
        return cell!

    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let otherPVC = OtherProfileMasterViewController(nibName: "ProfileMasterViewController", bundle: nil)
        let user = userList[indexPath.row]
        otherPVC.tenUser = user
        otherPVC.userID = user.UserIndex
        self.navigationController?.pushViewController(otherPVC, animated: true)
        self.usersTV.deselectRowAtIndexPath(indexPath, animated: true)

    }
}
