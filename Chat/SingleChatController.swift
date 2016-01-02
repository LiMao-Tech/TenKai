                        //
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
    var messages = NSMutableArray()
    var bottom : UIView!
    var addBtn : UIButton!
    var faceBtn : UIButton!
    var sendBtn : UIButton!
    var contentText : UITextView!
    var messageList : UITableView!
    var bottomImage : UIImageView!
    var faceView:GTFaceView!
    var member = NSDictionary()
    let margin:CGFloat = 5
    let iconSize: CGFloat = 30
    var contentHeight: CGFloat = 32
    var assets: [DKAsset]?
    
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
        // Do any additional setup after loading the view.
    }
    
    
    
    func refreshControl(){
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: "refreshStateChange:", forControlEvents: .ValueChanged)
        
        self.messageList.addSubview(refresh)
    }
    
    func refreshStateChange(refresh:UIRefreshControl){
        refresh.endRefreshing()
    }

    
    func getMessages(){

        let request : NSMutableURLRequest = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "post"
        let myID = NSUserDefaults.standardUserDefaults().objectForKey("myID") as! String
        let memberID = member.objectForKey("MemberId") as! Int
        let body = NSString(string:"MemberID=\(myID)&ReceiverID=\(memberID)")
        request.HTTPBody = body.dataUsingEncoding(NSUTF8StringEncoding)
        print(body)
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: { (response:NSURLResponse?, responseData: NSData?, error:NSError?) -> Void in
            let dict: NSDictionary = (try! NSJSONSerialization.JSONObjectWithData(responseData!, options: NSJSONReadingOptions.MutableContainers)) as! NSDictionary
            let memberList = dict.objectForKey("Msg List") as! NSString
            let messagesContent = (try! NSJSONSerialization.JSONObjectWithData(memberList.dataUsingEncoding(NSUTF8StringEncoding)!, options:NSJSONReadingOptions.MutableContainers)) as! NSMutableArray
            
            if(messagesContent.count > 0){
                for message in messagesContent{
                    let chatFrame = SingleChatMessageFrame()
//                    print(message)
                    let message = SingleChatMessage(dict: (message as! NSDictionary))
                    let stringToAtt = self.stringToAttributeString(message.Msg)
                    message.attrMsg = stringToAtt.text
                    message.isString = stringToAtt.isString
                    chatFrame.chatMessage = message
                    if(Int(myID) != chatFrame.chatMessage.SenderId){
                        chatFrame.chatMessage.belongType = ChatBelongType.Other
                    }
                    self.messages.addObject(chatFrame)
                }
            }
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                self.messageList.reloadData()
                self.rollToLastRow()
            })
        })
    }
    
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let chatFrame = messages[indexPath.row] as! SingleChatMessageFrame
        return chatFrame.cellHeight
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let oID = "otherchat"
        let mID = "mechat"
        var cell: ChatBaseCell?
        let message:SingleChatMessageFrame = messages[indexPath.row] as! SingleChatMessageFrame
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
                "Sender": 1,
                "Receiver": 1,
                "PhoneType": 0,
                "IsLocked": false,
                "MsgType": 1,
                "MsgTime": formatter.stringFromDate(currTime),
                "MsgContent": text
            ]
            
            AFNetworkTools.postMethod(MsgUrl, parameters: params as! [String : AnyObject], success: { (task, response) -> Void in
                print("postMsg")
                print(response)
                self.getMessages()
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
    
    // string转attributeString
    func stringToAttributeString(matchString:String) -> (text:NSMutableAttributedString,isString:Bool) {
        let Str:NSString = matchString as NSString
        var isString = true
        let pattern = "\\[\\d{3}\\]"
        var text = NSMutableAttributedString(string: matchString)
        var array = Array<NSTextCheckingResult>()
        let expression=try! NSRegularExpression(pattern: pattern, options: NSRegularExpressionOptions.CaseInsensitive)
        expression.enumerateMatchesInString(matchString, options: NSMatchingOptions.ReportCompletion, range: NSMakeRange(0, matchString.characters.count)) { (result, flag, stop) -> Void in
            if((result) != nil){
                    array.append(result!)
            }
        }
        
        if(array.count > 0){
            isString = false
            let len = text.length - (array[array.count-1].range.location + array[array.count-1].range.length)
            for(var i = array.count - 1; i >= 0; i--){
                let attr = NSMutableAttributedString(attributedString: text)
                let temp = Str.substringWithRange((array[i].range)) as NSString
                let temp0 = attr.attributedSubstringFromRange(NSMakeRange(0, array[i].range.location))
                let location1 = array[i].range.location + array[i].range.length
                let len1 = attr.length - location1
                let temp1 = attr.attributedSubstringFromRange(NSMakeRange(location1, len1))
                if(self.faceView.faceCodes.containsObject(temp)){
                    let attachment = GTTextAttachment()
                    attachment.image = UIImage(named:temp.substringWithRange(NSMakeRange(1, 3)) as String)
                    attachment.faceCode = temp
                    let attStr = NSAttributedString(attachment: attachment)
                    attr.setAttributedString(NSAttributedString(string: ""))
                    attr.appendAttributedString(temp0)
                    attr.setAttributes([NSFontAttributeName: UIFont.systemFontOfSize(15)], range: NSMakeRange(0, temp0.length))
                    attr.appendAttributedString(attStr)
                    attr.appendAttributedString(temp1)
                    attr.setAttributes([NSFontAttributeName: UIFont.systemFontOfSize(15)], range: NSMakeRange(attr.length-len,len))
                    text = attr
                }
            }
        }
        return (text,isString)
    }
}

