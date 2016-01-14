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
                            GTFaceButtonDelegate,
                            UITextViewDelegate,
                            UIActionSheetDelegate,
                            UIImagePickerControllerDelegate,
                            UINavigationControllerDelegate
{
    
    var tenUser = TenUser(){
        didSet{
            messages = UserChatModel.allChats().message[tenUser.UserIndex]!
            
        }
    }
    
    var messages: [SingleChatMessageFrame]! 
    
    var bottom : UIView!
    var addBtn : UIButton!
    var faceBtn : UIButton!
    var sendBtn : UIButton!
    var contentText : UITextView!
    var messageList : UITableView!
    var bottomImage : UIImageView!
    var faceView : GTFaceView!
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

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        refreshControl()
        UserChatModel.allChats().addObserver(self, forKeyPath: "message", options: .New, context: nil)
        // Do any additional setup after loading the view.
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if(keyPath == "message"){
            self.messages = UserChatModel.allChats().message[tenUser.UserIndex]
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
        refresh.endRefreshing()
    }

    
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self)
        UserChatModel.allChats().removeObserver(self, forKeyPath: "message")
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
        var cell: ChatBaseCell?
        let message:SingleChatMessageFrame = messages[indexPath.row]
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
        cell?.chatFrame = message
        return cell!
    }
    
    /**
    GTFaceButton代理函数
    */
    func faceButtonDidClicked(faceBtn: GTFaceButton) {
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
                "MsgTime": formatter.stringFromDate(currTime),
                "MsgContent": text
            ]
            
            let chatFrame = SingleChatMessageFrame()
            chatFrame.chatMessage = SingleChatMessage(dict: params)
            UserChatModel.allChats().message[tenUser.UserIndex]?.append(chatFrame)
            AFNetworkTools.postMethod(MsgUrl, parameters: params as! [String : AnyObject], success: { (task, response) -> Void in
                print("postMsg")
                print(response)
                MessageCacheTool(userIndex: self.tenUser.UserIndex).addMessageInfo(self.tenUser.UserIndex, msg: chatFrame.chatMessage)
                },
                failure: { (task, error) -> Void in
                    print("Post User Failed")
            })
            contentText.text = ""
            frameChange()
        }
    }
    
    // 点击加号按钮
    func addBtnClicked(){
       let actionsheet = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil, otherButtonTitles: "Attach Photo", "Transfer P Coin")
        actionsheet.showInView(self.view)
    }
    
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        switch buttonIndex {
        case 1:
            self.choosePhoto()
        case 2:
            self.transformCoin()
        default:
            break
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
                message.MsgTime = Tools.getNormalTime(NSDate())
                message.MsgContent = ""
                message.MsgImage = asset.fullResolutionImage
                if(self.messages.count > 0){
                    message.MsgIndex = (self.messages.last?.chatMessage.MsgIndex)!+1
                }else{
                    message.MsgIndex = SHARED_USER.MsgIndex+1
                }
                msgFrame.chatMessage = message
                UserChatModel.allChats().message[self.tenUser.UserIndex]?.append(msgFrame)
                let data = UIImageJPEGRepresentation(message.MsgImage!,0.75)!
                let params = ["sender":SHARED_USER.UserIndex,"receiver":self.tenUser.UserIndex,"phoneType":0,"time":message.MsgTime]
//                let params = ["sender":7,"receiver":14,"phoneType":0,"time":message.MsgTime]
                AFNetworkTools.postUserImage(data, parameters: params as! [String : AnyObject], success: { (task, response) -> Void in
                        print("postImage success")
                        print("response")
                        MessageCacheTool(userIndex: self.tenUser.UserIndex).addMessageInfo(self.tenUser.UserIndex, msg: message)
                    }, failure: { (task, error) -> Void in
                        print("post Image failed")
                        print(error.localizedDescription)
                })
            }
        }
        
        self.presentViewController(pickerController, animated: true) {}
    }
    func transformCoin(){
        print("coin")
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
        
        if(needTransfrom){
            UIView.animateWithDuration(0, animations: { () -> Void in
                self.bottom.transform = CGAffineTransformMakeTranslation(0, -h)
                var temp = self.messageList.frame
                temp.size.height -= h-self.keyBoardHeight
                self.messageList.frame = temp
                self.keyboardIsShow = true
                print("out")
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
        if(needTransfrom){
            UIView.animateWithDuration(0, animations: {() -> Void in
                self.bottom.transform = CGAffineTransformMakeTranslation(0, 0)
                var temp = self.messageList.frame
                temp.size.height += h
                self.messageList.frame = temp
                self.keyboardIsShow = false
                print("in")
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
        let background = UIImageView(frame: CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT))
        background.image = UIImage(named: "bg_chat_")
        self.view.backgroundColor = UIColor.clearColor()
        faceView = GTFaceView(faceDelegateTemp:self)
        
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
    
    
    
}

