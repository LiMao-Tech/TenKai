//
//  NotificationViewController.swift
//  Ten
//
//  Created by gt on 15/10/12.
//  Copyright © 2015年 LiMao Tech. All rights reserved.
//

import UIKit

class NotificationViewController: UIViewController,UITableViewDataSource,UITableViewDelegate{

    // Declarations
    var notification = [NotificationFrame]()
    var system = [NotificationFrame]()
    var tabView : UIView!
    var infoList : UITableView!
    var modelType : systemType = .System
    var selectedBtn : SettingButton!

    // View Controls
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.title = NotificationTitle
        seperateNotification()
        setUp()
        refreshControl()
        print("system number : \(system.count)")
        print("notification number : \(notification.count)")
        UserChatModel.allChats().addObserver(self, forKeyPath: "notifications", options: .New, context: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBar.hidden = false
    }
    
    func seperateNotification(){
        system.removeAll()
        notification.removeAll()
        for noti in SHARED_CHATS.notifications.reverse(){
            if(noti.notification.MsgType == 0){
                system .append(noti)
            }else{
                notification.append(noti)
            }
        }
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if(keyPath == "notifications"){
            seperateNotification()
            self.infoList.reloadData()
        }else{
            super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
        }
    }
    
    func refreshControl(){
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(NotificationViewController.refreshStateChange(_:)), forControlEvents: .ValueChanged)
        self.infoList.addSubview(refresh)
    }
    
    func refreshStateChange(refresh:UIRefreshControl){
        refresh.endRefreshing()
        print("refreshed")
    }
    
    func itemClicked(sender:SettingButton){
        selectedBtn.setBackgroundImage(selectedBtn.normalImage, forState: .Normal)
        selectedBtn = sender
        sender.setBackgroundImage(sender.seletedImage, forState: .Normal)
        modelType = sender.systemModel
        self.infoList.reloadData()
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return (modelType == .System) ? system[indexPath.row].cellheight : notification[indexPath.row].cellheight
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = infoList.dequeueReusableCellWithIdentifier("notificationInfoCell") as? NotificationInfoCell
        if(cell == nil){
            cell = NotificationInfoCell.init(style: UITableViewCellStyle.Default, reuseIdentifier: "notificationInfoCell")
        }
        if(modelType == .System){
            cell?.notificationFrame = system[indexPath.row]
        }else{
            cell?.notificationFrame = notification[indexPath.row]
        }
        
        return cell!

    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (modelType == .System) ? system.count : notification.count
    }

    deinit{
        UserChatModel.allChats().removeObserver(self, forKeyPath: "notifications")
    }
    
    func setUp(){
        //tabview
        tabView = UIView(frame: CGRectMake(0, 64, SCREEN_WIDTH, TAP_BAR_HEIGHT))
        
        let itemSystem = SettingButton(frame: CGRectMake(0, 0, SCREEN_WIDTH/2, TAP_BAR_HEIGHT))
        let itemNotification = SettingButton(frame: CGRectMake(CGRectGetMaxX(itemSystem.frame), 0, SCREEN_WIDTH/2, TAP_BAR_HEIGHT))
        
        itemSystem.normalImage = nil
        itemSystem.seletedImage = UIImage(named: "tabBar_bg_chat")
        itemSystem.setTitle("系统", forState: .Normal)
        itemSystem.backgroundColor = COLOR_TAP
        itemNotification.normalImage = nil
        itemNotification.seletedImage = UIImage(named: "tabBar_bg_chat")
        itemNotification.setTitle("通知", forState: .Normal)
        itemNotification.backgroundColor = COLOR_TAP
        itemSystem.setBackgroundImage(itemSystem.seletedImage, forState: UIControlState.Normal)
        itemNotification.setBackgroundImage(itemNotification.normalImage, forState: UIControlState.Normal)
        itemSystem.addTarget(self, action: #selector(NotificationViewController.itemClicked(_:)), forControlEvents: .TouchUpInside)
        itemNotification.addTarget(self, action: #selector(NotificationViewController.itemClicked(_:)), forControlEvents: .TouchUpInside)
        itemSystem.systemModel = .System
        itemNotification.systemModel = .Notification
        
        tabView.addSubview(itemNotification)
        tabView.addSubview(itemSystem)
        
        // list
        infoList = UITableView(frame: CGRectMake(0, CGRectGetMaxY(tabView.frame), SCREEN_WIDTH, SCREEN_HEIGHT - CGRectGetMaxY(tabView.frame)))
        
        infoList.backgroundColor = UIColor.clearColor()
        infoList.delegate = self
        infoList.dataSource = self
        infoList.separatorStyle = .None
        
        //addsubview
        self.view.addSubview(tabView)
        self.view.addSubview(infoList)
        
        selectedBtn = itemSystem
        self.view.backgroundColor = COLOR_BG

    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
