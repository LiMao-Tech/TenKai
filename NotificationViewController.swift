//
//  NotificationViewController.swift
//  Ten
//
//  Created by gt on 15/10/12.
//  Copyright © 2015年 LiMao Tech. All rights reserved.
//

import UIKit

class NotificationViewController: UIViewController,UITableViewDataSource,UITableViewDelegate{
    var tabView:UIView!
    var infoList:UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.translucent = false
        self.navigationItem.title = "Notification"
        //tabview
        tabView = UIView(frame: CGRectMake(0, 0, SCREEN_WIDTH, TAP_BAR_HEIGHT))
        let item = UIButton(frame: CGRectMake(0, 0, SCREEN_WIDTH/2, TAP_BAR_HEIGHT))
        let item0 = UIButton(frame: CGRectMake(CGRectGetMaxX(item.frame), 0, SCREEN_WIDTH/2, TAP_BAR_HEIGHT))
        item.setImage(UIImage(named: "tab_notification_systems"), forState: UIControlState.Normal)
        item0.setImage(UIImage(named: "tab_notification_notification"), forState: UIControlState.Normal)
        tabView.addSubview(item0)
        tabView.addSubview(item)
        
        //list
        infoList = UITableView(frame: CGRectMake(0, CGRectGetMaxY(tabView.frame), SCREEN_WIDTH, SCREEN_HEIGHT - CGRectGetMaxY(tabView.frame)))
        infoList.backgroundColor = UIColor.clearColor()
        infoList.delegate = self
        infoList.dataSource = self
        infoList.separatorStyle = .None
        
        //addsubview
        self.view.addSubview(tabView)
        self.view.addSubview(infoList)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let note = Notification()
        let noteFrame = NotificationFrame()
        noteFrame.notification = note
        print(noteFrame.cellheight)
        return noteFrame.cellheight
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = infoList.dequeueReusableCellWithIdentifier("notificationInfoCell") as? NotificationInfoCell
        if(cell == nil){
            cell = NotificationInfoCell.init(style: UITableViewCellStyle.Default, reuseIdentifier: "notificationInfoCell")
        }
        let note = Notification()
        let noteFrame = NotificationFrame()
        noteFrame.notification = note
        cell?.notificationFrame = noteFrame
        return cell!

    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
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
