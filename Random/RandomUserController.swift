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
                            UITableViewDataSource {
    
    // Declarations
    var userListView : UITableView!
    var userList = [AnyObject]()
    
    // View Controls
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get users from the server and update the table view
        getUserList()
        
        self.title = RandomTitle
        userListView = UITableView(frame: CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT))
        userListView.dataSource = self
        userListView.delegate = self
        userListView.backgroundColor = BG_COLOR
        userListView.separatorStyle = .None
        
        self.view.addSubview(userListView)
        refreshControl()
    }
    
    func refreshControl(){
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: "refreshStateChange:", forControlEvents: .ValueChanged)
        
        self.userListView.addSubview(refresh)
    }
    
    func refreshStateChange(refresh:UIRefreshControl){
        
        // TODO: Get Users here
        getUserList()
        refresh.endRefreshing()
        print("refreshed")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let otherProfileVC = OtherProfileViewController()
        self.navigationController?.pushViewController(otherProfileVC, animated: true)
    }
    
    
    // Table view delegates
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        // TODO: 这个值要按屏幕比例来进行调整。
        return 75
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.userList.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell = RandomAndLevelUserCell()
        let user = JSON(userList[indexPath.row] as! [String: AnyObject])
        
        cell.nameLabel.text = user["UserName"].stringValue
        
        let inner = user["InnerScore"].intValue
        let outer = user["OuterScore"].intValue
        let energy = user["Energy"].intValue
        let avg = (inner+outer)/2

        cell.innerLabel.text = "内在 \(inner)"
        cell.outerLabel.text = "外在 \(outer)"
        cell.energyLabel.text = "能量 \(energy)"
        cell.avgLabel.text = "平均 \(avg)"
        
        cell.distanceLabel.text = "距离 0"
        
        return cell
    }
    
    private func getUserList() -> Void {
        ALAMO_MANAGER.request(.GET, UserUrl, parameters: nil)
            .responseJSON { response in
                if let values = response.result.value {
                    self.userList = (values as? [AnyObject])!
                    self.userListView.reloadData()
                }
        }
    }

}
