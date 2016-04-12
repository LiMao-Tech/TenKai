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

    let refresh = UIRefreshControl()

    // Declarations
    var userListView: UITableView!
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
        

        refresh.addTarget(self, action: #selector(RandomUserController.refreshList(_:)), forControlEvents: .ValueChanged)
        
        self.view.addSubview(userListView)
        self.userListView.addSubview(refresh)
    }
    
    override func viewWillAppear(animated: Bool) {
        refresh.beginRefreshing()
        TenOtherUsersJSONManager.SharedInstance.getUserListRandom(self, refresh: refresh)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    func refreshList(refresh: UIRefreshControl){
        TenOtherUsersJSONManager.SharedInstance.getUserListRandom(self, refresh: refresh)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let otherPVC = OtherProfileMasterViewController(nibName: "ProfileMasterViewController", bundle: nil)

        let user = users[indexPath.row]
        otherPVC.tenUser = user
        otherPVC.userID = user.UserIndex
        self.navigationController?.pushViewController(otherPVC, animated: true)
        self.userListView.deselectRowAtIndexPath(indexPath, animated: true)
        
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
        if(user.PortraitImage == nil){
            let imageIndex = user.UserIndex.description
            let targetUrl = Url_GetHeadImage + imageIndex
            ALAMO_MANAGER.request(.GET, targetUrl).responseImage { response in
                if let image = response.result.value {
                    user.Portrait = UIImagePNGRepresentation(image)
                    self.userListView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .None)
                }
            }

        }
        cell!.user = user
        
        return cell!
    }
}
