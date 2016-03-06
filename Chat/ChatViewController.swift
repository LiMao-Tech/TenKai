//
//  ChatViewController.swift
//  userlist

//
//  Created by gt on 15/10/12. Modified by Yumen Cao
//  Copyright © 2015年 LiMao Tech. All rights reserved.
//

import UIKit

var ChatFocusState = false

var ChatLockState = false

class ChatViewController: UIViewController, UITableViewDataSource, UITableViewDelegate,UserCellDelegate {
    
    var userChatActive = [TenUser]()
    var userChatInActive = [TenUser]()
    var tabView : UIView!
    var userList : UITableView!
    var modelType : chatType = .Active
    var selectedBtn : SettingButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = ChatTitle
        UserChatModel.allChats().addObserver(self, forKeyPath: "tenUser", options: NSKeyValueObservingOptions.New, context: nil)
        UserChatModel.allChats().addObserver(self, forKeyPath: "message", options: NSKeyValueObservingOptions.New, context: nil)
        
        if(NSUserDefaults.standardUserDefaults().valueForKey("ChatFocusState") != nil){
            ChatFocusState = true
        }
        
        separateUser()
        setup()
        refreshControl()

        
        // userList.reloadData()
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func viewWillAppear(animated: Bool) {
        for user in userChatInActive{
            let count = UserChatModel.allChats().message[user.UserIndex]?.count
            if(count > 1){
                for index in 1...(count!-1){
                    if(UserChatModel.allChats().message[user.UserIndex]![index].chatMessage.Sender != UserChatModel.allChats().message[user.UserIndex]![index-1].chatMessage.Sender){
                        user.listType = .Active
                    }
                }
            }
        }
        separateUser()
        self.userList.reloadData()
    }
    
    //UserCellDelegate func
    func menuDeleteBtnDidClicked(cell: UserCell) {
        
    }
    
    func menuInfoBtnDidClicked(cell: UserCell) {
        
    }
    
    func menuMidLockBtnDidClicked(cell: UserCell) {
        
    }
    
    func separateUser(){
        userChatActive.removeAll()
        userChatInActive.removeAll()
        for uc in UserChatModel.allChats().tenUser{
            if uc.listType == .InActive {
                userChatInActive.append(uc)
            }else{
                userChatActive.append(uc)
            }
        }
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if(keyPath == "tenUser"){
            print(UserChatModel.allChats().tenUser)
            separateUser()
            self.userList.reloadData()
        }else if(keyPath == "message"){
            separateUser()
            self.userList.reloadData()
        }else{
            super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
        }
    }
    deinit{
        UserChatModel.allChats().removeObserver(self, forKeyPath: "tenUser", context: nil)
        UserChatModel.allChats().removeObserver(self, forKeyPath: "message", context: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 85
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = userList.dequeueReusableCellWithIdentifier("userCell") as? UserCell
        if(cell == nil){
            cell = UserCell.loadFromNib()
        }
        if(modelType == .Active){
            cell?.tenUser = userChatActive[indexPath.row]
            cell?.delegate = self
        }else{
            cell?.tenUser = userChatInActive[indexPath.row]
            cell?.delegate = self
        }
        return cell!
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modelType == chatType.Active ? userChatActive.count : userChatInActive.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let sVC = SingleChatController()
        if(modelType == .Active){
            sVC.tenUser = userChatActive[indexPath.row]
        }else{
            sVC.tenUser = userChatInActive[indexPath.row]
        }
        
        if(!sVC.tenUser.isRatered && !ChatFocusState){
            ChatFocusState = true
            NSUserDefaults.standardUserDefaults().setValue(sVC.tenUser.UserIndex, forKey: "ChatFocusState")
        }
        
        if(ChatFocusState && sVC.tenUser.UserIndex != NSUserDefaults.standardUserDefaults().valueForKey("ChatFocusState") as! Int){
            let focusAlert = UIAlertController(title: "注意！", message: "还没有为你的小伙伴的内在评分", preferredStyle: .Alert)
            let focusAction = UIAlertAction(title: "确定", style: .Cancel, handler: { (ac) -> Void in
                let index = NSUserDefaults.standardUserDefaults().valueForKey("ChatFocusState") as! Int
                for user in UserChatModel.allChats().tenUser{
                    if(user.UserIndex == index){
                        sVC.tenUser = user
                        self.navigationController?.pushViewController(sVC, animated: true)
                        self.userList.deselectRowAtIndexPath(indexPath, animated: true)
                        return
                    }
                }
            })
            focusAlert.addAction(focusAction)
            self.presentViewController(focusAlert, animated: true, completion: nil)
        }else{
            self.navigationController?.pushViewController(sVC, animated: true)
            self.userList.deselectRowAtIndexPath(indexPath, animated: true)
        }
    }
    
    
    
    func refreshControl(){
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: "refreshStateChange:", forControlEvents: .ValueChanged)
        
        self.userList.addSubview(refresh)
    }
    
    func refreshStateChange(refresh:UIRefreshControl){
        refresh.endRefreshing()
    }

    func itemClicked(sender:SettingButton){
        selectedBtn.setImage(selectedBtn.normalImage, forState: .Normal)
        selectedBtn = sender
        sender.setImage(sender.seletedImage, forState: .Normal)
        modelType = sender.chatModel
        userList.reloadData()
    }
    
    func setup(){
        tabView = UIView(frame: CGRectMake(0, 64, SCREEN_WIDTH, TAP_BAR_HEIGHT))
        
        let itemActive = SettingButton(frame: CGRectMake(0, 0, SCREEN_WIDTH/2, TAP_BAR_HEIGHT))
        let itemInactive = SettingButton(frame: CGRectMake(SCREEN_WIDTH/2, 0, SCREEN_WIDTH/2, TAP_BAR_HEIGHT))
        
        itemActive.normalImage = UIImage(named: "tab_chat_activeChats_normal")
        itemActive.seletedImage = UIImage(named: "tab_chat_activeChats_highlight")
        itemActive.chatModel = .Active
        itemActive.contentMode = .ScaleAspectFit
        itemActive.setImage(itemActive.seletedImage, forState: UIControlState.Normal)
        itemActive.addTarget(self, action: "itemClicked:", forControlEvents: .TouchUpInside)
        
        itemInactive.normalImage = UIImage(named: "tab_chat_inactiveChats_normal")
        itemInactive.seletedImage = UIImage(named: "tab_chat_inactiveChats_highlight")
        itemInactive.chatModel = .InActive
        itemInactive.contentMode = .ScaleAspectFill
        itemInactive.setImage(itemInactive.normalImage, forState: UIControlState.Normal)
        itemInactive.addTarget(self, action: "itemClicked:", forControlEvents: .TouchUpInside)
        
        
        tabView.addSubview(itemActive)
        tabView.addSubview(itemInactive)
        
        userList = UITableView(frame: CGRectMake(0, CGRectGetMaxY(tabView.frame), SCREEN_WIDTH, SCREEN_HEIGHT - CGRectGetMaxY(tabView.frame)))
        userList.backgroundColor = UIColor.clearColor()
        userList.delegate = self
        userList.dataSource = self
        userList.separatorStyle = .None
        
        self.view.addSubview(tabView)
        self.view.addSubview(userList)
        self.view.backgroundColor = COLOR_BG
        
        if(NSUserDefaults.standardUserDefaults().valueForKey("ChatFocusState") != nil){
            ChatFocusState = true
        }
        
        selectedBtn = itemActive
    }

}
