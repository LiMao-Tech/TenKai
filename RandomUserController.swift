//
//  RandomUserController.swift
//  Ten
//
//  Created by gt on 15/10/12.
//  Copyright © 2015年 LiMao Tech. All rights reserved.
//

import UIKit

class RandomUserController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    var userList:UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        refreshControl()
        // Do any additionalsetup after loading the view.
    }
    
    func setup(){
        self.title = randomTitle
        userList = UITableView(frame: CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64))
        userList.dataSource = self
        userList.delegate = self
        userList.backgroundColor = UIColor.blackColor()
        userList.separatorStyle = .None
        self.view.addSubview(userList)
    
    }
    func refreshControl(){
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: "refreshStateChange:", forControlEvents: .ValueChanged)
        
        self.userList.addSubview(refresh)
    }
    
    func refreshStateChange(refresh:UIRefreshControl){
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
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 75
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = userList.dequeueReusableCellWithIdentifier("RALUserCell") as? RandomAndLevelUserCell
        if(cell == nil){
            cell = RandomAndLevelUserCell.init(style: UITableViewCellStyle.Default, reuseIdentifier: "RALUserCell")
        }
        cell?.RALuser = RandomAndLevelUser()
        return cell!
    }

}
