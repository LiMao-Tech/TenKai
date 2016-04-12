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

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        refreshControl()
    }
    override func viewWillAppear(animated: Bool) {
        userList = TenOtherUsersJSONManager.SharedInstance.selectLevelUsers(level)
        self.usersTV.reloadData()
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
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(LevelUserController.refreshStateChange(_:)), forControlEvents: .ValueChanged)
        
        self.usersTV.addSubview(refresh)
    }
    
    func refreshStateChange(refresh:UIRefreshControl){
        userList.removeAll()
        userList = TenOtherUsersJSONManager.SharedInstance.selectLevelUsers(level)
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
        if(user.PortraitImage == nil){
            let imageIndex = user.UserIndex
            let targetUrl = Url_GetHeadImage + String(imageIndex)
            ALAMO_MANAGER.request(.GET, targetUrl)
                .responseImage { response in
                    if let image = response.result.value {
                        user.Portrait = UIImagePNGRepresentation(image)
                        self.usersTV.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .None)
                    }
            }

        }
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
