//  SingleChatController.swift
//  swiftChat
//
//  Created by gt on 15/9/1. Modifed by Yumen Cao
//  Copyright (c) 2015年 gt. All rights reserved.
//

import UIKit

class SingleChatController : UIViewController,
                            UITableViewDelegate,
                            UITableViewDataSource,
                            TenFaceButtonDelegate,
                            UITextViewDelegate,
                            UIActionSheetDelegate,
                            UIImagePickerControllerDelegate,
                            UINavigationControllerDelegate,
                            ScoreViewDelegate,
                            PCoinTransDelegate,
                            ChatBaseCellDelegate
{
    var messages:[SingleChatMessageFrame]!
    var tenUser = TenUser(){
        didSet{
            if(!SHARED_CHATS.activeUserIndex.contains(tenUser.UserIndex) && !SHARED_CHATS.inActiveUserIndex.contains(tenUser.UserIndex)){
                print("add new user")
                SHARED_CHATS.tenUsers[tenUser.UserIndex] = tenUser
                SHARED_CHATS.inActiveUserIndex.insert(tenUser.UserIndex, atIndex: 0)
                UserListCache().updateUserList()
                SHARED_CHATS.message[tenUser.UserIndex] = [SingleChatMessageFrame]()
                UsersCacheTool().addUserInfoByUser(tenUser)
            }
            
            tenUser.badgeNum = 0
            UsersCacheTool().updateUsersBadgeNum(tenUser.UserIndex, badgeNum: 0)
            comunicatingIndex = tenUser.UserIndex
            messages = SHARED_CHATS.message[tenUser.UserIndex]!
        }
    }
    
    var scoreView:ScoreView?
    var pcoinView:PCoinTransView?
    
    var bottom : UIView!
    var addBtn : UIButton!
    var faceBtn : UIButton!
    var sendBtn : UIButton!
    var contentText : UITextView!
    var messageList : UITableView!
    var bottomImage : UIImageView!
    var faceView : TenFaceView!
    var member = NSDictionary()
    let margin : CGFloat = 5
    let iconSize : CGFloat = 30
    var contentHeight : CGFloat = 32
    var assets : [DKAsset]?
    
    //keyboard properties
    var duration = 0.25
    var keyboardIsShow = false
    var needTransfrom = true
    var initialFrame:CGRect!
    var keyBoardHeight:CGFloat = 0
    var leftItem:UIBarButtonItem!
    
    var otherUnreadNum = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getOtherUnreadNum()
        var unreadNum = otherUnreadNum < 100 ? "(\(otherUnreadNum))" : "(99+)"
        if(otherUnreadNum == 0){
            unreadNum = ""
        }
        leftItem = UIBarButtonItem(title: "返回"+unreadNum, style: .Done, target: self, action: "backClicked")
        let rightItem = UIBarButtonItem(image: UIImage(named:"btn_navBarIcon_caht_more"), style: .Done, target: self, action: "moreBtnClicked")
        self.navigationItem.setLeftBarButtonItem(leftItem, animated: true)
        self.navigationItem.setRightBarButtonItem(rightItem, animated: true)
        setup()
        refreshControl()
        
        SHARED_CHATS.addObserver(self, forKeyPath: "message", options: .New, context: nil)
        // Do any additional setup after loading the view.
    }
    
    
    deinit{
     SHARED_CHATS.removeObserver(self, forKeyPath: "message")
    }
    
    override func viewWillAppear(animated: Bool) {
        self.title = tenUser.UserName
    }
    
    func moreBtnClicked(){
        self.view.endEditing(true)
        let actionsheet = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: "取消", destructiveButtonTitle: nil, otherButtonTitles: "用户信息", "删除对话")
        actionsheet.tag = 1
        actionsheet.destructiveButtonIndex = 2
        actionsheet.showInView(self.view)
    }
    
    func getOtherUnreadNum(){
        if(tenUser.listType == .Active){
            for userIndex in SHARED_CHATS.activeUserIndex{
                otherUnreadNum += (SHARED_CHATS.tenUsers[userIndex]?.badgeNum)!
            }
        }else{
            for userIndex in SHARED_CHATS.inActiveUserIndex{
                otherUnreadNum += (SHARED_CHATS.tenUsers[userIndex]?.badgeNum)!
            }
        }
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if(keyPath == "message"){
            getOtherUnreadNum()
            var unreadNum = otherUnreadNum < 100 ? "(\(otherUnreadNum))" : "(99+)"
            if(otherUnreadNum == 0){
                unreadNum = ""
            }
            leftItem.title = "返回"+unreadNum
            self.messages = UserChatModel.allChats().message[tenUser.UserIndex]!
            self.messageList.reloadData()
            self.rollToLastRow()
        }else{
            super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
        }
    }
    //remove observer

    
    func refreshControl(){
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: "refreshStateChange:", forControlEvents: .ValueChanged)
        self.messageList.addSubview(refresh)
    }
    
    func refreshStateChange(refresh:UIRefreshControl){
        if(messages.count == 0){
            getMessageByNet(refresh, index: SHARED_USER.MsgIndex+1)
        }
        else{
            let result = MessageCacheTool(userIndex: tenUser.UserIndex).loadMessage(tenUser.UserIndex, msgIndex: (self.messages.first?.chatMessage.MsgIndex)!)
            print("msgindex:")
            print(self.messages.first?.chatMessage.MsgIndex)
            if(result.isEmpty){
                print("get from net")
                getMessageByNet(refresh, index: (self.messages.first?.chatMessage.MsgIndex)!)
            }else{
                print("get from db")
                SHARED_CHATS.message[tenUser.UserIndex] = result.messageFrames + messages
                self.messageList.reloadData()
                refresh.endRefreshing()
                rollToRow(result.messageFrames.count)
            }
        }
        
    }
    
    func getMessageByNet(refresh:UIRefreshControl,index:Int){
        let url = Url_Api + "TenMsgs?sender=\(SHARED_USER.UserIndex)&receiver=\(tenUser.UserIndex)&msgIndx=\(index)&amount=20"
        let newUrl = url.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
        AFJSONManager.SharedInstance.getMethod(newUrl!, success: { (task, response) -> Void in
            print(response)
            var msgTemp = [SingleChatMessageFrame]()
            let msgArray = response as! NSArray
            for msg in msgArray{
                let dict = msg as! NSDictionary
                let singleCMF = SingleChatMessageFrame()
                let sCM = SingleChatMessage(dict: dict)
                singleCMF.chatMessage = sCM
                msgTemp.append(singleCMF)
                MessageCacheTool(userIndex: self.tenUser.UserIndex).addMessageInfo(self.tenUser.UserIndex, msg: sCM)
            }
            
                SHARED_CHATS.message[self.tenUser.UserIndex] = msgTemp + self.messages
                self.messageList.reloadData()
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                if(msgArray.count == 0){
                    self.rollToRow(0)
                }else{
                    self.rollToRow(msgArray.count-1)
                }
               
            })
           
            refresh.endRefreshing()
            }, failure: { (task, error) -> Void in
                print("sgvc get msg failed")
                print(error.localizedDescription)
                refresh.endRefreshing()
        })
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let chatFrame = messages[indexPath.row]
        return chatFrame.cellHeight
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let oID = "otherchat"
        let mID = "mechat"
        let pID = "pcoin"
        var cell: ChatBaseCell?
        let message:SingleChatMessageFrame = messages[indexPath.row]
        if(message.chatMessage.messageType == .Pcoin){
            cell = messageList.dequeueReusableCellWithIdentifier(pID) as? ChatBaseCell
            if(cell == nil){
                cell = PCoinCell.loadFromNib()
            }
        }else{
            if(message.chatMessage.belongType == ChatBelongType.Other){
                cell = messageList.dequeueReusableCellWithIdentifier(oID) as? ChatBaseCell
                if(cell == nil){
                    cell = OtherChatCell.loadFromNib()
                }
            }else{
                cell = messageList.dequeueReusableCellWithIdentifier(mID) as? ChatBaseCell
                if(cell == nil){
                    cell = MeChatCell.loadFromNib()
                }
            }
        }
        cell?.chatFrame = message
        cell?.tenUser = self.tenUser
        cell?.delegate = self
        return cell!
    }
    //chatbasecelldelegate
    func unlockBtnClicked(cell: ChatBaseCell) {
        let msg = cell.chatFrame.chatMessage
        MessageCacheTool(userIndex: tenUser.UserIndex).upDateLockState(tenUser.UserIndex, MsgIndex: msg.MsgIndex, isLock: msg.IsLocked)
    }
    /**
    GTFaceButton代理函数
    */
    func faceButtonDidClicked(faceBtn: TenFaceButton) {
        let conText = NSMutableAttributedString()
        conText.setAttributes([NSFontAttributeName:UIFont.systemFontOfSize(15)], range: NSMakeRange(0, 0))
        conText.appendAttributedString(self.contentText.attributedText)
        let attachment = GTTextAttachment()
        attachment.image = faceBtn.faceImage
        attachment.faceCode = faceBtn.faceCode
        let str = NSAttributedString(attachment: attachment)
        conText.appendAttributedString(str)
        conText.appendAttributedString(NSAttributedString(string: ""))
        self.contentText.attributedText = conText
        print(self.contentText.contentSize.height)
        self.frameChange()
        
    }
    
    func sendBtnClicked() {
        if((contentText.attributedText.length > 0) && !contentText.text.isEmpty){
            let text = self.attributeStringToString()
            
            let formatter = NSDateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let currTime = NSDate()
            
            let params : NSDictionary = [
                "Sender": SHARED_USER.UserIndex,
                "Receiver": tenUser.UserIndex,
                "PhoneType": 0,
                "IsLocked": false,
                "MsgType": 0,
                "MsgTime": Tools.getSinceTime(currTime),
                "MsgContent": text
            ]
            
            let chatFrame = SingleChatMessageFrame()
            chatFrame.chatMessage = SingleChatMessage(dict: params)
            messages.append(chatFrame)
            self.messageList.reloadData()
            AFJSONManager.SharedInstance.postMethod(Url_Msg, parameters: params as? [String : AnyObject], success: { (task, response) -> Void in
                print("postMsg")
                print(response)
                let message = SingleChatMessage(dict: response as! NSDictionary)
                chatFrame.chatMessage = message
                SHARED_CHATS.message[self.tenUser.UserIndex]?.append(chatFrame)
                MessageCacheTool(userIndex: self.tenUser.UserIndex).addMessageInfo(self.tenUser.UserIndex, msg: message)
                    SHARED_USER.MsgIndex = message.MsgIndex
                    UserCacheTool().upDateUserMsgIndex()
                },
                failure: { (task, error) -> Void in
                    print("Post User Failed")
                    print(error.localizedDescription)
            })
            contentText.text = ""
            frameChange()
        }
    }
    
    // 点击加号按钮
    func addBtnClicked(){
        self.view.endEditing(true)
       let actionsheet = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: "取消", destructiveButtonTitle: nil, otherButtonTitles: "相   册", "赠送P币")
        actionsheet.showInView(self.view)
    }
    
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        if(actionSheet.tag == 0){
            switch buttonIndex{
            case 1:
                self.choosePhoto()
            case 2:
                self.transformCoin()
            default:
                break
            }
        }else if(actionSheet.tag == 1){
            switch buttonIndex{
            case 1:
                self.showProfile()
            case 2:
                self.deleteConversation()
            default:
                break
            }

        }
    }
    
    func choosePhoto(){
        print("photo")
        let pickerController = DKImagePickerController()
        
        pickerController.singleSelect = false
        pickerController.maxSelectableCount = 3
        
        pickerController.assetType = DKImagePickerControllerAssetType.allAssets
        pickerController.allowMultipleTypes = true
        pickerController.sourceType = [.Camera, .Photo]
        
        pickerController.didCancel = { () in
            print("did cancel")
        }
        //didSelectImages
        pickerController.didSelectAssets = { [unowned self] (assets: [DKAsset]) in
            self.assets = assets
            print("did select assets")
            print(assets.map({ $0.url}))
            for asset in assets{
                let msgFrame = SingleChatMessageFrame()
                let message = SingleChatMessage()
                message.MsgType = 1
                message.Sender = SHARED_USER.UserIndex
                message.Receiver = self.tenUser.UserIndex
                message.MsgTime = Tools.getSinceTime(NSDate())
                message.MsgContent = ""
                message.MsgImage = asset.fullResolutionImage
                if(self.messages.count > 0){
                    message.MsgIndex = (self.messages.last?.chatMessage.MsgIndex)!+1
                }else{
                    message.MsgIndex = SHARED_USER.MsgIndex+1
                }
                msgFrame.chatMessage = message
                self.messages.append(msgFrame)
                self.messageList.reloadData()
                let data = UIImageJPEGRepresentation(message.MsgImage!,0.75)!
                let params = ["sender":SHARED_USER.UserIndex,"receiver":self.tenUser.UserIndex,"phoneType":0]
                AFImageManager.SharedInstance.postUserImage(Url_SendImage,image: data, parameters: params, success: { (task, response) -> Void in
                        print("postImage success")
                    let dict = try! NSJSONSerialization.JSONObjectWithData(response as! NSData, options: NSJSONReadingOptions.AllowFragments) as! NSDictionary
                    print(dict)
                    let imageMsg = SingleChatMessage(dict: dict)
                    imageMsg.MsgImage = asset.fullResolutionImage
                    msgFrame.chatMessage = imageMsg
                    SHARED_USER.MsgIndex = imageMsg.MsgIndex
                    UserCacheTool().upDateUserMsgIndex()
                    SHARED_CHATS.message[self.tenUser.UserIndex]?.append(msgFrame)
                        MessageCacheTool(userIndex: self.tenUser.UserIndex).addMessageInfo(self.tenUser.UserIndex, msg: imageMsg)
                    }, failure: { (task, error) -> Void in
                        print("post Image failed")
                        print(error.localizedDescription)
                })
            }
        }
        
        self.presentViewController(pickerController, animated: true) {}
    }
    //赠送PCoin
    func transformCoin(){
        if(pcoinView == nil){
            pcoinView = PCoinTransView()
        }
        pcoinView?.tenUser = tenUser
        pcoinView?.delegate = self
        pcoinView?.isShow = true
        self.view.addSubview(pcoinView!)
    }
    
    func showProfile(){
        let pVC = OtherProfileMasterViewController(nibName: "ProfileMasterViewController", bundle: nil)
        pVC.tenUser = tenUser
        self.navigationController?.pushViewController(pVC, animated: true)
    }
    
    func deleteConversation(){
        if(tenUser.listType == .Active){
            let index = SHARED_CHATS.activeUserIndex.indexOf(tenUser.UserIndex)
            SHARED_CHATS.activeUserIndex.removeAtIndex(index!)
        }else{
            let index = SHARED_CHATS.inActiveUserIndex.indexOf(tenUser.UserIndex)
            SHARED_CHATS.inActiveUserIndex.removeAtIndex(index!)
        }
        UserListCache().updateUserList()
        UsersCacheTool().deleteUserInfo(tenUser.UserIndex)
        if(ChatFocusState && NSUserDefaults.standardUserDefaults().valueForKey("ChatFocusState") as! Int == tenUser.UserIndex){
            ChatFocusState = false
            NSUserDefaults.standardUserDefaults().removeObjectForKey("ChatFocusState")
        }
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    // 点击表情按钮
    func faceBtnClicked(){
        if(keyboardIsShow){
            needTransfrom = false
        }else{
            needTransfrom = true
        }
        contentText.resignFirstResponder()
        if((contentText.inputView) == nil){
            contentText.inputView = faceView
            faceBtn.setImage(UIImage(named: "btn_chat_keyboard"), forState:UIControlState.Normal)
            
        }else{
            contentText.inputView = nil
            faceBtn.setImage(UIImage(named: "btn_chat_emoji"), forState:UIControlState.Normal)
        }
        contentText.becomeFirstResponder()
    }
    
    // 键盘弹出
    func keyboardWillShow(note:NSNotification){

        let userInfo:NSDictionary = note.userInfo!
        let aValue = userInfo.objectForKey(UIKeyboardFrameEndUserInfoKey) as! NSValue
        let value = aValue.CGRectValue()
        let h = value.height
        if(pcoinView != nil && pcoinView!.isShow){
            self.pcoinView?.transform = CGAffineTransformMakeTranslation(0,-SCREEN_HEIGHT*0.2)
            return
        }
        if(needTransfrom){
            UIView.animateWithDuration(0, animations: { () -> Void in
                self.bottom.transform = CGAffineTransformMakeTranslation(0, -h)
                var temp = self.messageList.frame
                temp.size.height -= h-self.keyBoardHeight
                self.messageList.frame = temp
                self.keyboardIsShow = true
            })
             self.rollToLastRow()
        }else{
            self.bottom.transform = CGAffineTransformMakeTranslation(0, -h)
            var temp = self.messageList.frame
            temp.size.height -= h-self.keyBoardHeight
            self.messageList.frame = temp
        }
        keyBoardHeight = h
    }
    
    // 键盘收回
    func keyboardWillHide(note:NSNotification){
        let userInfo:NSDictionary = note.userInfo!
        let aValue = userInfo.objectForKey(UIKeyboardFrameEndUserInfoKey) as! NSValue
        let value = aValue.CGRectValue()
        let h = value.height
        if(pcoinView != nil && pcoinView!.isShow){
            self.pcoinView?.transform = CGAffineTransformMakeTranslation(0,0)
            return
        }
        if(needTransfrom ){
            UIView.animateWithDuration(0, animations: {() -> Void in
                self.bottom.transform = CGAffineTransformMakeTranslation(0, 0)
                var temp = self.messageList.frame
                temp.size.height += h
                self.messageList.frame = temp
                self.keyboardIsShow = false
            })
            self.rollToLastRow()
        }
        if(!keyboardIsShow){
            keyBoardHeight = 0
        }
    }
    /**
    滚动消息的tableview调用
    */
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        needTransfrom = true
        self.view.endEditing(true)
    }
    
    
    /**
    当输入变化时调用
    */
    func textViewDidChange(textView: UITextView) {
        if(contentText.attributedText.length > 0){
            let str = NSMutableAttributedString(attributedString: contentText.attributedText)
            str.setAttributes([NSFontAttributeName: UIFont.systemFontOfSize(15)], range: NSRange(location: contentText.attributedText.length-1,length: 1))
            contentText.attributedText = str
        }
        frameChange()
    }
    
    func frameChange(){
        var contentFrame = self.contentText.frame
        if(contentText.contentSize.height > 81){
            contentFrame.size.height = 81
        }
        else if(contentText.contentSize.height < 38){
            contentFrame.size.height = 32
        }else{
            contentFrame.size.height = contentText.contentSize.height
        }
        print(contentText.contentSize.height)
        
        if(contentHeight != contentFrame.size.height){
            var tableFrame = self.messageList.frame
            var bottomFrame = self.bottom.frame
            var addFrame = self.addBtn.frame
            var faceFrame = self.faceBtn.frame
            var sendFrame = self.sendBtn.frame
            bottomFrame.size.height = contentFrame.size.height + 12
            if !keyboardIsShow {
                bottomFrame.origin.y = SCREEN_HEIGHT - bottomFrame.size.height
            }
            else {
                bottomFrame.origin.y = SCREEN_HEIGHT - bottomFrame.size.height - keyBoardHeight
            }
            
            tableFrame.size.height = bottomFrame.origin.y - 64
            contentFrame.origin.y = bottomFrame.height - contentFrame.size.height - 6
            addFrame.origin.y = bottomFrame.height - 36
            sendFrame.origin.y = bottomFrame.height - 36
            faceFrame.origin.y = bottomFrame.height - 36
            
            self.sendBtn.frame = sendFrame
            self.addBtn.frame = addFrame
            self.faceBtn.frame = faceFrame
            self.messageList.frame = tableFrame
            self.bottom.frame = bottomFrame
            self.bottomImage.frame = self.bottom.bounds
            self.contentText.frame = contentFrame
            
            contentHeight = contentFrame.size.height
        }
        contentFrame.size = self.contentText.contentSize
        self.contentText.scrollRectToVisible(contentFrame, animated: false)
    }
    /**
    *  滚动到最后一行
    */
    func rollToLastRow(){
        let last = messageList.numberOfRowsInSection(0)-1
        if(last > 0){
            let index = NSIndexPath(forRow: last, inSection: 0)
            messageList.scrollToRowAtIndexPath(index, atScrollPosition: UITableViewScrollPosition.Top, animated: false)
        }
    }
    
    func rollToRow(index:Int){
        if(index >= 0){
            let index = NSIndexPath(forRow: index, inSection: 0)
            messageList.scrollToRowAtIndexPath(index, atScrollPosition: UITableViewScrollPosition.Top, animated: false)
        }
    }
    
    // attributeString转换String
    func attributeStringToString() -> String {
        
        let attrString = NSMutableAttributedString()
        attrString.appendAttributedString(contentText.attributedText)
        attrString.enumerateAttributesInRange(NSMakeRange(0, attrString.length), options: NSAttributedStringEnumerationOptions.Reverse) { (attrs, range, stop) -> Void in
            let attr = attrs["NSAttachment"] as? GTTextAttachment
            if(attr != nil){
                print(attr!.faceCode)
                let faceCode = attr!.faceCode
                attrString.replaceCharactersInRange(range, withString: faceCode as String)
            }
        }
        return attrString.string
    }
    
    func setup(){
        faceView = TenFaceView(faceDelegateTemp:self)
        
        bottom = UIView(frame: CGRectMake(0, SCREEN_HEIGHT-44, SCREEN_WIDTH, 44))
        
        bottomImage = UIImageView(frame: bottom.bounds)
        bottomImage.image = UIImage(named: "navBar_blank")
        
        addBtn = UIButton(frame: CGRectMake(margin, bottom.bounds.height - iconSize - 7.0, iconSize, iconSize))
        addBtn.setImage(UIImage(named: "btn_chat_plus"), forState:UIControlState.Normal)
        addBtn.addTarget(self, action: "addBtnClicked", forControlEvents: UIControlEvents.TouchUpInside)
        
        faceBtn = UIButton(frame: CGRectMake(CGRectGetMaxX(addBtn.frame) + margin, bottom.bounds.height - iconSize - 7.0, iconSize, iconSize))
        faceBtn.setImage(UIImage(named: "btn_chat_emoji"), forState:UIControlState.Normal)
        faceBtn.addTarget(self, action: "faceBtnClicked", forControlEvents: UIControlEvents.TouchUpInside)
        
        sendBtn = UIButton(frame: CGRectMake(SCREEN_WIDTH-35, bottom.bounds.height - iconSize - 7.0, iconSize, iconSize))
        sendBtn.setImage(UIImage(named: "btn_chat_sendsmg"), forState:UIControlState.Normal)
        sendBtn.addTarget(self, action: "sendBtnClicked", forControlEvents: UIControlEvents.TouchUpInside)
        
        contentText = UITextView(frame: CGRectMake(CGRectGetMaxX(faceBtn.frame) + margin, 6, SCREEN_WIDTH-3*iconSize-5*margin, 32))
        contentText.delegate = self
        contentText.layer.masksToBounds = true
        contentText.layer.cornerRadius = 3
        contentText.bounces = false
        contentText.font = UIFont.systemFontOfSize(15)
        
        messageList = UITableView(frame: CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64-44))
        messageList.separatorStyle = UITableViewCellSeparatorStyle.None
        messageList.backgroundColor = UIColor(red: 236.0/255.0, green: 236.0/255.0, blue: 236.0/255.0, alpha: 1.0)
        messageList.allowsSelection = false
        messageList.dataSource = self
        messageList.delegate = self
        messageList.bounces = true
        messageList.allowsSelection = false
        initialFrame = messageList.frame
        
        // add all the items
        
        bottom.addSubview(bottomImage)
        bottom.addSubview(addBtn)
        bottom.addSubview(faceBtn)
        bottom.addSubview(sendBtn)
        bottom.addSubview(contentText)
        self.view.addSubview(bottom)
        self.view.addSubview(messageList)
        
        // getMessages()
        self.rollToLastRow()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    //delegete funcs for scoreView
    func scoreViewOkBtnClicked() {
        let score = Int((scoreView?.scoreSlider.value)!)
        //post new score of the other person
        let params = ["RaterIndex": SHARED_USER.UserIndex,
            "UserIndex": tenUser.UserIndex,
            "OuterScore": -1,
            "InnerScore": score,
            "Energy": -1,
            "Active": true]
        AFJSONManager.SharedInstance.postMethod(Url_Rater, parameters: params as? [String : AnyObject], success: { (task, response) -> Void in
                self.tenUser.listType = .Active
                self.tenUser.isRatered = true
                let index = SHARED_CHATS.inActiveUserIndex.indexOf(self.tenUser.UserIndex)
                SHARED_CHATS.inActiveUserIndex.removeAtIndex(index!)
                SHARED_CHATS.activeUserIndex.insert(self.tenUser.UserIndex, atIndex: 0)
                UserListCache().updateUserList()
                UsersCacheTool().updateUserInfo(self.tenUser)
                ChatFocusState = false
                SHARED_CHATS.raterIndex.append(self.tenUser.UserIndex)
                UserRaterCache().addUserRater(self.tenUser.UserIndex)
                comunicatingIndex = 0
                NSUserDefaults.standardUserDefaults().removeObjectForKey("ChatFocusState")
                self.navigationController?.popViewControllerAnimated(true)
                self.scoreView!.removeFromSuperview()
            },failure: { (task, error) -> Void in
                print("post rater error:")
                print(error.localizedDescription)
                let scoreFailed = UIAlertController(title: "评分失败", message: "请重评分，以解锁锁定状态", preferredStyle: .Alert)
                let failAction = UIAlertAction(title: "确定", style: UIAlertActionStyle.Destructive, handler: nil)
                scoreFailed.addAction(failAction)
                self.presentViewController(scoreFailed, animated: true, completion: nil)
        })
    }
    
    func scoreViewCancelBtnClicked() {
        comunicatingIndex = 0
        scoreView!.removeFromSuperview()
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func scoreViewScoreChange() {
        scoreView!.scoreLabel.text = "\(Int(scoreView!.scoreSlider.value))"
    }
    //delegete funcs for PCoinTransView
    func PCoinTransViewOkBtnClicked() {
        if(!pcoinView!.pcoinTF.text!.isEmpty){
            //赠送pcoin
                let pcoinAmount = Double(pcoinView!.pcoinTF.text!)
                if(pcoinAmount == 0){
                    print("pcoin = 0")
                    return
                }
                print("transpcoin start")
                if(pcoinAmount > SHARED_USER.PCoin){
                    print("pcoin less")
                    let pcoinTransFail = UIAlertController(title: "赠送失败", message: "没有足够的P币，请购买", preferredStyle: .Alert)
                    let okAction = UIAlertAction(title: "购买", style: UIAlertActionStyle.Destructive, handler:{ (ac) -> Void in
                        let pVC = PCoinViewController()
                        self.navigationController?.pushViewController(pVC, animated: true)
                    })
                    let cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: nil)
                    pcoinTransFail.addAction(okAction)
                    pcoinTransFail.addAction(cancelAction)
                    self.presentViewController(pcoinTransFail, animated: true, completion: nil)
                    return
                }
                let params:[String:AnyObject] = ["Sender": SHARED_USER.UserIndex,
                    "Receiver": tenUser.UserIndex,
                    "PhoneType": SHARED_USER.PhoneType,
                    "Amount": pcoinAmount!,
                    "TransTime": Tools.getSinceTime(NSDate())
                ]
            
            AFJSONManager.SharedInstance.postMethod(Url_PCoin, parameters: params, success: { (task, response)
                    -> Void in
                    let chatFrame = SingleChatMessageFrame()
                    let message = SingleChatMessage()
                    message.Sender = SHARED_USER.UserIndex
                    message.Receiver = self.tenUser.UserIndex
                    message.MsgType = 2
                    let msgs = UserChatModel.allChats().message[self.tenUser.UserIndex]
                    if(msgs!.count > 0){
                        message.MsgIndex = (msgs?.last?.chatMessage.MsgIndex)! + 1
                    }
                    message.MsgContent = String(pcoinAmount!)
                    chatFrame.chatMessage = message
                    UserChatModel.allChats().message[self.tenUser.UserIndex]?.append(chatFrame)
                    MessageCacheTool(userIndex: self.tenUser.UserIndex).addMessageInfo(self.tenUser.UserIndex, msg: message)
                    SHARED_USER.PCoin -= pcoinAmount!
                    UserCacheTool().upDateUserPCoin()
                    self.pcoinView!.removeFromSuperview()
                    self.pcoinView!.isShow = false
                }, failure: { (task, error) -> Void in
                    print("pcoin trans error:")
                    print(error.localizedDescription)
                    let pcoinTransFail = UIAlertController(title: "赠送失败", message: "请重新尝新赠送P币", preferredStyle: .Alert)
                    let okAction = UIAlertAction(title: "确定", style: UIAlertActionStyle.Destructive, handler: nil)
                    pcoinTransFail.addAction(okAction)
                    self.presentViewController(pcoinTransFail, animated: true, completion: nil)

            })
            
        }else{
            let emptyPcoin = UIAlertController(title: "赠送P币", message: "请输入P币数量", preferredStyle: .Alert)
            let okAction = UIAlertAction(title: "确定", style: UIAlertActionStyle.Destructive, handler: nil)
            emptyPcoin.addAction(okAction)
            self.presentViewController(emptyPcoin, animated: true, completion: nil)
            
        }
        
    }
    
    func PCoinTransViewCancelBtnClicked() {
        pcoinView!.removeFromSuperview()
        pcoinView!.isShow = false
    }
    
    func backClicked(){
        if(tenUser.listType == .Active && tenUser.isRatered == false){
            if(scoreView == nil){
                scoreView = ScoreView()
            }
            scoreView!.tenUser = tenUser
            scoreView!.delegate = self
            self.view.addSubview(scoreView!)
        }else{
            comunicatingIndex = 0
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
    
    
}
