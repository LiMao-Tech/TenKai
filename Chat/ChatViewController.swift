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
    
    var userChatActive = SHARED_CHATS.activeUserIndex
    var userChatInActive = SHARED_CHATS.inActiveUserIndex
    var tabView : UIView!
    var userList : UITableView!
    var modelType : chatType = .Active
    var selectedBtn : SettingButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = ChatTitle
        SHARED_CHATS.addObserver(self, forKeyPath: "tenUser", options: NSKeyValueObservingOptions.New, context: nil)
        SHARED_CHATS.addObserver(self, forKeyPath: "message", options: NSKeyValueObservingOptions.New, context: nil)
        
        if(NSUserDefaults.standardUserDefaults().valueForKey("ChatFocusState") != nil){
            ChatFocusState = true
        }
        
        setup()
        refreshControl()

        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(animated: Bool) {
        if(!ChatFocusState){
            for userIndex in userChatInActive{
                let count = SHARED_CHATS.message[userIndex]?.count
                if(SHARED_CHATS.raterIndex.contains(userIndex)){
                    print("rater contains")
                    let user = SHARED_CHATS.tenUsers[userIndex]!
                    user.listType = .Active
                    user.isRatered = true
                    UsersCacheTool().updateUserInfo(user)
                    let index = userChatInActive.indexOf(userIndex)
                    userChatInActive.removeAtIndex(index!)
                    userChatActive.insert(userIndex, atIndex: 0)
                    
                    break
                }
                if(count > 1){
                    print(count)
                    for index in 1...(count!-1){
                        print(SHARED_CHATS.message[userIndex]![index].chatMessage.Sender)
                        if(SHARED_CHATS.message[userIndex]![index].chatMessage.Sender != SHARED_CHATS.message[userIndex]![index-1].chatMessage.Sender){
                            let user = SHARED_CHATS.tenUsers[userIndex]
                            user!.listType = .Active
                            UsersCacheTool().updateUserInfo(user!)
                            ChatFocusState = true
                            NSUserDefaults.standardUserDefaults().setValue(userIndex, forKey: "ChatFocusState")
                            print("listTypeChanged & into focusState")
                            return
                        }
                    }
                }
            }
        }
        self.userList.reloadData()
    }
    
    //UserCellDelegate func
    func menuDeleteBtnDidClicked(cell: UserCell) {
        
    }
    
    func menuInfoBtnDidClicked(cell: UserCell) {
        
    }
    
    func menuMidLockBtnDidClicked(cell: UserCell) {
        
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if(keyPath == "tenUser"){
            print(SHARED_CHATS.tenUser)
            self.userList.reloadData()
        }else if(keyPath == "message"){
            self.userList.reloadData()
        }else{
            super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
        }
    }
    deinit{
        SHARED_CHATS.removeObserver(self, forKeyPath: "tenUser", context: nil)
        SHARED_CHATS.removeObserver(self, forKeyPath: "message", context: nil)
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
            cell?.tenUser =  SHARED_CHATS.tenUsers[userChatActive[indexPath.row]]!
            cell?.delegate = self
        }else{
            cell?.tenUser = SHARED_CHATS.tenUsers[userChatInActive[indexPath.row]]!
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
            sVC.tenUser = SHARED_CHATS.tenUsers[userChatActive[indexPath.row]]!
        }else{
            sVC.tenUser = SHARED_CHATS.tenUsers[userChatInActive[indexPath.row]]!
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
