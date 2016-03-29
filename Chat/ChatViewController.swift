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

var comunicatingIndex = 0

class ChatViewController: UIViewController, UITableViewDataSource, UITableViewDelegate,UserCellDelegate {
    
//    var userChatActive = SHARED_CHATS.activeUserIndex
//    var userChatInActive = SHARED_CHATS.inActiveUserIndex
    
    var tabView : UIView!
    var userList : UITableView!
    var modelType : chatType = .Active
    var selectedBtn : SettingButton!
    
    var itemActive:SettingButton!
    var itemInactive:SettingButton!
    
    var titleActive:String{
        get{
            var numAc = 0
            for index in SHARED_CHATS.activeUserIndex{
                numAc += (SHARED_CHATS.tenUsers[index]?.badgeNum)!
            }
            if(numAc == 0){
                return "聊天中"
            }
            return "聊天中(\(numAc))"
        }
    }
    var titleInActive:String{
        get{
            var numInAc = 0
            for index in SHARED_CHATS.inActiveUserIndex{
                numInAc += (SHARED_CHATS.tenUsers[index]?.badgeNum)!
            }
            if(numInAc == 0){
                return "等待中"
            }
            return "等待中(\(numInAc))"
        }
    }
    var chatLockActiveIndex : [Int]{
        get{
            var temp = [Int]()
            for index in SHARED_CHATS.activeUserIndex{
                if(SHARED_CHATS.tenUsers[index]?.isLocked == false){
                    temp.append(index)
                }
            }
            return temp
        }
    }
    
    var chatLockInActiveIndex:[Int]{
        get{
            var temp = [Int]()
            for index in SHARED_CHATS.inActiveUserIndex{
                if(SHARED_CHATS.tenUsers[index]?.isLocked == false){
                    temp.append(index)
                }
            }
            return temp
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = ChatTitle
        SHARED_CHATS.addObserver(self, forKeyPath: "activeUserIndex", options: NSKeyValueObservingOptions.New, context: nil)
         SHARED_CHATS.addObserver(self, forKeyPath: "inActiveUserIndex", options: NSKeyValueObservingOptions.New, context: nil)
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
            for userIndex in SHARED_CHATS.inActiveUserIndex{
                let count = SHARED_CHATS.message[userIndex]?.count
                if(SHARED_CHATS.raterIndex.contains(userIndex)){
                    print("rater contains:\(userIndex)")
                    let user = SHARED_CHATS.tenUsers[userIndex]!
                    user.listType = .Active
                    user.isRatered = true
                    UsersCacheTool().updateUserInfo(user)
                    moveInActiveToActive(userIndex)
                    continue
                }
                if(count > 1 && !ChatFocusState){
                    print(count)
                    for index in 1...(count!-1){
                        print(SHARED_CHATS.message[userIndex]![index].chatMessage.Sender)
                        if(SHARED_CHATS.message[userIndex]![index].chatMessage.Sender != SHARED_CHATS.message[userIndex]![index-1].chatMessage.Sender){
                            let user = SHARED_CHATS.tenUsers[userIndex]
                            user!.listType = .Active
                            UsersCacheTool().updateUserInfo(user!)
                            moveInActiveToActive(userIndex)
                            ChatFocusState = true
                            NSUserDefaults.standardUserDefaults().setValue(userIndex, forKey: "ChatFocusState")
                            print("listTypeChanged & into focusState")
                            break
                        }
                    }
                }
            }
        }
        self.itemActive.setTitle(titleActive, forState: .Normal)
        self.itemInactive.setTitle(titleInActive, forState: .Normal)
        self.userList.reloadData()
    }
    
    func moveInActiveToActive(userIndex:Int){
        let index = SHARED_CHATS.inActiveUserIndex.indexOf(userIndex)
        SHARED_CHATS.inActiveUserIndex.removeAtIndex(index!)
        SHARED_CHATS.activeUserIndex.insert(userIndex, atIndex: 0)
        UserListCache().updateUserList()
    }
    
    //UserCellDelegate func
    func menuDeleteBtnDidClicked(cell: UserCell) {
        let user = cell.tenUser
        print(user.UserIndex)
        var index = 0
        if(user.listType == .Active){
            index = SHARED_CHATS.activeUserIndex.indexOf(user.UserIndex)!
            SHARED_CHATS.activeUserIndex.removeAtIndex(index)
        }else{
            index = SHARED_CHATS.inActiveUserIndex.indexOf(user.UserIndex)!
            SHARED_CHATS.inActiveUserIndex.removeAtIndex(user.UserIndex)
        }
        UsersCacheTool().deleteUserInfo(user.UserIndex)
        UserListCache().updateUserList()
        self.userList.reloadData()
    }
    
    func menuInfoBtnDidClicked(cell: UserCell) {
        let pVC = OtherProfileMasterViewController(nibName: "ProfileMasterViewController", bundle: nil)
        pVC.userID = cell.tenUser.UserIndex
        pVC.tenUser = cell.tenUser
        pVC.pushVCType = 1
        self.navigationController?.pushViewController(pVC, animated: true)
    }
    
    func menuMidLockBtnDidClicked(cell: UserCell) {
        cell.lockBtnDidClicked()
    }
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if(keyPath == "activeUserIndex"){
            self.userList.reloadData()
        }else if(keyPath == "inActiveUserIndex"){
            self.userList.reloadData()
        }else if(keyPath == "message"){
            self.itemActive.setTitle(titleActive, forState: .Normal)
            self.itemInactive.setTitle(titleInActive, forState: .Normal)
            self.userList.reloadData()
        }else{
            super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
        }

    }
    deinit{
        SHARED_CHATS.removeObserver(self, forKeyPath: "activeUserIndex", context: nil)
        SHARED_CHATS.removeObserver(self, forKeyPath: "inActiveUserIndex", context: nil)
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
            let indexArray = ChatLockState ? self.chatLockActiveIndex : SHARED_CHATS.activeUserIndex
            cell?.tenUser =  SHARED_CHATS.tenUsers[indexArray[indexPath.row]]!
            cell?.delegate = self
        }else{
            let indexArray = ChatLockState ? self.chatLockInActiveIndex : SHARED_CHATS.inActiveUserIndex
            cell?.tenUser = SHARED_CHATS.tenUsers[indexArray[indexPath.row]]!
            cell?.delegate = self
        }
        return cell!
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        if(!ChatLockState){
            count = modelType == chatType.Active ? SHARED_CHATS.activeUserIndex.count : SHARED_CHATS.inActiveUserIndex.count
        }else{
            count = modelType == chatType.Active ? self.chatLockActiveIndex.count : self.chatLockInActiveIndex.count
        }
        return count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let sVC = SingleChatController()
        if(modelType == .Active){
            let indexArray = ChatLockState ? self.chatLockActiveIndex : SHARED_CHATS.activeUserIndex
            sVC.tenUser =  SHARED_CHATS.tenUsers[indexArray[indexPath.row]]!
        }else{
            let indexArray = ChatLockState ? self.chatLockInActiveIndex : SHARED_CHATS.inActiveUserIndex
            sVC.tenUser = SHARED_CHATS.tenUsers[indexArray[indexPath.row]]!
        }
        
        if(ChatFocusState && sVC.tenUser.UserIndex != NSUserDefaults.standardUserDefaults().valueForKey("ChatFocusState") as! Int){
            let focusAlert = UIAlertController(title: "注意！", message: "还没有为你的小伙伴的内在评分", preferredStyle: .Alert)
            let focusAction = UIAlertAction(title: "确定", style: .Cancel, handler: { (ac) -> Void in
                let index = NSUserDefaults.standardUserDefaults().valueForKey("ChatFocusState") as! Int
                sVC.tenUser = SHARED_CHATS.tenUsers[index]!
                self.navigationController?.pushViewController(sVC, animated: true)
                self.userList.deselectRowAtIndexPath(indexPath, animated: true)
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
        refresh.addTarget(self, action: #selector(ChatViewController.refreshStateChange(_:)), forControlEvents: .ValueChanged)
        
        self.userList.addSubview(refresh)
    }
    
    func refreshStateChange(refresh:UIRefreshControl){
        refresh.endRefreshing()
    }

    func itemClicked(sender:SettingButton){
        selectedBtn.setBackgroundImage(selectedBtn.normalImage, forState: .Normal)
        selectedBtn = sender
        sender.setBackgroundImage(sender.seletedImage, forState: .Normal)
        modelType = sender.chatModel
        userList.reloadData()
    }
    
    func setup(){
        tabView = UIView(frame: CGRectMake(0, 64, SCREEN_WIDTH, TAP_BAR_HEIGHT))
        let tabBgc = UIColor(red: 41.0/255.0, green: 43.0/255.0, blue: 45.0/255.0, alpha: 1.0)
        itemActive = SettingButton(frame: CGRectMake(0, 0, SCREEN_WIDTH/2, TAP_BAR_HEIGHT))
        itemInactive = SettingButton(frame: CGRectMake(SCREEN_WIDTH/2, 0, SCREEN_WIDTH/2, TAP_BAR_HEIGHT))
        
        itemActive.normalImage = nil
        itemActive.seletedImage = UIImage(named: "tabBar_bg_chat")
        itemActive.chatModel = .Active
        itemActive.contentMode = .ScaleAspectFit
        itemActive.setBackgroundImage(itemActive.seletedImage, forState: UIControlState.Normal)
        itemActive.setTitle(titleActive, forState: .Normal)
        itemActive.backgroundColor = tabBgc
        itemActive.addTarget(self, action: #selector(ChatViewController.itemClicked(_:)), forControlEvents: .TouchUpInside)
        
        itemInactive.normalImage = nil
        itemInactive.seletedImage = UIImage(named: "tabBar_bg_chat")
        itemInactive.chatModel = .InActive
        itemInactive.contentMode = .ScaleAspectFill
        itemInactive.setBackgroundImage(itemInactive.normalImage, forState: UIControlState.Normal)
        itemInactive.setTitle(titleInActive, forState: .Normal)
        itemInactive.backgroundColor = tabBgc
        itemInactive.addTarget(self, action: #selector(ChatViewController.itemClicked(_:)), forControlEvents: .TouchUpInside)
        
        
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
