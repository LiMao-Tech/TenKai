//
//  RandomUserController.swift
//  Ten
//
//  Created by gt on 15/10/12.
//  Copyright © 2015年 LiMao Tech. All rights reserved.
//

import UIKit
import SwiftyJSON



class RandomUserController: UIViewController,
                            UITableViewDelegate,
                            UITableViewDataSource
{
    // Declarations
    var userListView : UITableView!
    var userList: [AnyObject] = [AnyObject]()
    var users = [TenUser]()
    // View Controls
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = RandomTitle
        userListView = UITableView(frame: CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT))
        userListView.dataSource = self
        userListView.delegate = self
        userListView.backgroundColor = COLOR_BG
        userListView.separatorStyle = .None
        
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: "refreshStateChange:", forControlEvents: .ValueChanged)
        
        self.view.addSubview(userListView)
        self.userListView.addSubview(refresh)
    }
    
    override func viewWillAppear(animated: Bool) {
        self.userList = TenOtherUsersJSONManager.SharedInstance.selectRandomUsers()
        for user in userList{
            let newUser = user as! [String: AnyObject]
            let tenUser = TenUser(dict: newUser)
            users.append(tenUser)
        }
        self.userListView.reloadData()
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    func refreshStateChange(refresh:UIRefreshControl){
        
        // TODO: Get Users here
        self.userList = TenOtherUsersJSONManager.SharedInstance.selectRandomUsers()
        self.userListView.reloadData()
        
        refresh.endRefreshing()
        print("refreshed")
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let otherPVC = OtherProfileMasterViewController(nibName: "ProfileMasterViewController", bundle: nil)

        let tenUser = users[indexPath.row]
        otherPVC.tenUser = tenUser
        otherPVC.userID = tenUser.UserIndex
        self.navigationController?.pushViewController(otherPVC, animated: true)
    }
    
    
    // Table view delegates
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return SCREEN_HEIGHT/8
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.users.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        var cell = userListView.dequeueReusableCellWithIdentifier("RALUserCell") as? RandomAndLevelUserCell
        if(cell == nil){
            cell = RandomAndLevelUserCell.init(style: UITableViewCellStyle.Default, reuseIdentifier: "RALUserCell")
        }
        
        let user = users[indexPath.row]
        
        let imageIndex = user.UserIndex.description
        let targetUrl = Url_GetHeadImage + imageIndex
        ALAMO_MANAGER.request(.GET, targetUrl)
            .responseImage { response in
                if let image = response.result.value {
                    cell!.headImage.setImage(image, forState: .Normal)
                    user.Portrait = UIImagePNGRepresentation(image)
                    user.PortraitImage = image
                }
        }
        
        cell!.nameLabel.text = user.UserName
        
        let inner = user.InnerScore
        let outer = user.OuterScore
        let energy = user.Energy
        let avg = (inner+outer)/2

        cell!.innerLabel.text = "内在 \(inner)"
        cell!.outerLabel.text = "外在 \(outer)"
        cell!.energyLabel.text = "能量 \(energy)"
        cell!.avgLabel.text = "平均 \(avg)"
        
        cell!.distanceLabel.text = "距离 0"
        
        return cell!
    }
}
