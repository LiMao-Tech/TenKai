//
//  ChatViewController.swift
//  userlist

//
//  Created by gt on 15/10/12.
//  Copyright © 2015年 LiMao Tech. All rights reserved.
//

import UIKit

let screenBounds = UIScreen.mainScreen().bounds

class ChatViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var tabView:UIView!
    var userList:UITableView!
    var modelType:chatType = .Active
    var selectedBtn:SettingButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = ChatTitle
        setup()
        refreshControl()
        //        userList.reloadData()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func setup(){
        tabView = UIView(frame: CGRectMake(0, 64, SCREEN_WIDTH, TAP_BAR_HEIGHT))
        let item = SettingButton(frame: CGRectMake(0, 0, SCREEN_WIDTH/2, TAP_BAR_HEIGHT))
        let item0 = SettingButton(frame: CGRectMake(CGRectGetMaxX(item.frame), 0, SCREEN_WIDTH/2, TAP_BAR_HEIGHT))
        item.normalImage = UIImage(named: "tab_chat_activeChats_normal")
        item.seletedImage = UIImage(named: "tab_chat_activeChats_highlight")
        item.contentMode = .ScaleAspectFit
        item0.normalImage = UIImage(named: "tab_chat_inactiveChats_normal")
        item0.seletedImage = UIImage(named: "tab_chat_inactiveChats_highlight")
        item0.contentMode = .ScaleAspectFill
        item.setImage(item.seletedImage, forState: UIControlState.Normal)
        item0.setImage(item0.normalImage, forState: UIControlState.Normal)
        item.addTarget(self, action: "itemClicked:", forControlEvents: .TouchUpInside)
        item0.addTarget(self, action: "itemClicked:", forControlEvents: .TouchUpInside)
        tabView.addSubview(item0)
        tabView.addSubview(item)
        
        userList = UITableView(frame: CGRectMake(0, CGRectGetMaxY(tabView.frame), SCREEN_WIDTH, SCREEN_HEIGHT - CGRectGetMaxY(tabView.frame)))
        userList.backgroundColor = UIColor.clearColor()
        userList.delegate = self
        userList.dataSource = self
        userList.separatorStyle = .None
        
        self.view.addSubview(tabView)
        self.view.addSubview(userList)
        self.view.backgroundColor = BG_COLOR
        
        selectedBtn = item
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

    func itemClicked(sender:SettingButton){
        selectedBtn.setImage(selectedBtn.normalImage, forState: .Normal)
        selectedBtn = sender
        sender.setImage(sender.seletedImage, forState: .Normal)
        modelType = sender.chatModel
        userList.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 90
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = userList.dequeueReusableCellWithIdentifier("userCell")
        if(cell == nil){
            cell = UserCell.loadFromNib()
        }
        return cell!
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let sVC = SingleChatController()
        self.navigationController?.pushViewController(sVC, animated: true)
        self.userList.deselectRowAtIndexPath(indexPath, animated: true)
        
    }
}
