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
        
        //tabview
        tabView = UIView(frame: CGRectMake(0, 64, SCREEN_WIDTH, TAP_BAR_HEIGHT))
        
        let item = SettingButton(frame: CGRectMake(0, 0, SCREEN_WIDTH/2, TAP_BAR_HEIGHT))
        let item0 = SettingButton(frame: CGRectMake(CGRectGetMaxX(item.frame), 0, SCREEN_WIDTH/2, TAP_BAR_HEIGHT))
        
        item.normalImage = UIImage(named: "tab_notification_system_normal")
        item.seletedImage = UIImage(named: "tab_notification_system_highlight")
        item0.normalImage = UIImage(named: "tab_notification_notification_normal")
        item0.seletedImage = UIImage(named: "tab_notification_notification_highlight")
        item.setImage(item.seletedImage, forState: UIControlState.Normal)
        item0.setImage(item0.normalImage, forState: UIControlState.Normal)
        item.addTarget(self, action: "itemClicked:", forControlEvents: .TouchUpInside)
        item0.addTarget(self, action: "itemClicked:", forControlEvents: .TouchUpInside)
        
        tabView.addSubview(item0)
        tabView.addSubview(item)
        
        // list
        infoList = UITableView(frame: CGRectMake(0, CGRectGetMaxY(tabView.frame), SCREEN_WIDTH, SCREEN_HEIGHT - CGRectGetMaxY(tabView.frame)))
        
        infoList.backgroundColor = UIColor.clearColor()
        infoList.delegate = self
        infoList.dataSource = self
        infoList.separatorStyle = .None
        
        //addsubview
        self.view.addSubview(tabView)
        self.view.addSubview(infoList)
        
        refreshControl()
        selectedBtn = item
        self.view.backgroundColor = BG_COLOR
        
        UserChatModel.allChats().addObserver(self, forKeyPath: "notifications", options: .New, context: nil)
    }
    
    func seperateNotification(){
        for noti in UserChatModel.allChats().notifications{
            if(noti.notification.MsgType == 0){
                notification.append(noti)
            }else{
                system.append(noti)
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
    
    override func viewWillAppear(animated: Bool) {

    }
    
    func refreshControl(){
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: "refreshStateChange:", forControlEvents: .ValueChanged)
        self.infoList.addSubview(refresh)
    }
    
    func refreshStateChange(refresh:UIRefreshControl){
        refresh.endRefreshing()
        print("refreshed")
    }
    
    func itemClicked(sender:SettingButton){
        selectedBtn.setImage(selectedBtn.normalImage, forState: .Normal)
        selectedBtn = sender
        sender.setImage(sender.seletedImage, forState: .Normal)
        modelType = sender.systemModel
        infoList.reloadData()
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        var cellHeight:CGFloat = 0.0
        if(modelType == .System){
            cellHeight = system[indexPath.row].cellheight
        }else{
            cellHeight = notification[indexPath.row].cellheight
        }
        return cellHeight
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
        var cellCount = 0
        
        if(modelType == .System){
            cellCount = system.count
        }else{
            cellCount = notification.count
        }
        
        return cellCount
    }

    deinit{
        UserChatModel.allChats().removeObserver(self, forKeyPath: "notifications")
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
