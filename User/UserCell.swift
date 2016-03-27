//
//  UserCell.swift
//  Ten
//
//  Created by gt on 15/10/18.
//  Copyright © 2015年 LiMao Tech. All rights reserved.
//

import UIKit
import JSBadgeView
protocol UserCellDelegate:class{
    func menuMidLockBtnDidClicked(cell:UserCell)
    func menuInfoBtnDidClicked(cell:UserCell)
    func menuDeleteBtnDidClicked(cell:UserCell)
}

class UserCell: UITableViewCell {
    var nameLabel:UILabel!
    var dotView:UIImageView!
    var splitLine:UIView!
    var panG:UIPanGestureRecognizer!
    var menuIsShow = false
    var initialX:CGFloat = 0
    var delegate:UserCellDelegate?
    var badgeView:JSBadgeView!
    @IBOutlet weak var lastMessage: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    var tenUser = TenUser(){
        didSet{
            nameLabel.text = tenUser.UserName
            var temp = [SingleChatMessageFrame()]
            if(ChatLockState){
                for msg in SHARED_CHATS.message[tenUser.UserIndex]!{
                    if(!msg.chatMessage.IsLocked){
                        temp.append(msg)
                    }
                }
            }else{
                temp = SHARED_CHATS.message[tenUser.UserIndex]!
            }
            message = temp
            let w = SCREEN_WIDTH - 190
            let attr = [NSFontAttributeName:UIFont.systemFontOfSize(15)]
            let size = tenUser.UserName.boundingRectWithSize(CGSizeMake(w, 21), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: attr, context: nil)
            nameLabel.frame = CGRectMake(CGRectGetMaxX(headImage.frame)+10, headImage.frame.origin.y, size.width, 21)
            nameLabel.text = tenUser.UserName
            nameLabel.textColor = UIColor.orangeColor()
            let x = CGRectGetMaxX(nameLabel.frame)
            dotView.frame =  CGRectMake(x+10, nameLabel.frame.origin.y+7, 7, 7)
            dotView.image = UIImage(named: "icon_chat_dot_l\(tenUser.Average)")
            var image : UIImage!
            if(tenUser.PortraitImage == nil){
                image = UIImage(named: "user_pic_radar")!
            }else{
                image = Tools.toCirclurImage(tenUser.PortraitImage!)
            }
            headImage.setImage(image, forState: .Normal)
            
            if(tenUser.badgeNum == 0){
                badgeView.hidden = true
            }else{
                badgeView.hidden = false
                badgeView.badgeText = tenUser.badgeNum < 100 ? String(tenUser.badgeNum) : "99+"
            }
            //清除bottomView 上的字控件
            for subview in bottomView.subviews {
                subview.removeFromSuperview()
            }
            
            if(tenUser.listType == .InActive){
                bottomLen = SCREEN_WIDTH/3
                let len = (bottomLen-1)/2
                let frame = CGRectMake(SCREEN_WIDTH-bottomLen, 0, bottomLen, 85)
                bottomView.frame = frame
                infoBtn = UIButton(frame: CGRectMake(0,0,len,85))
                infoBtn.setImage(UIImage(named: "btn_chat_info"), forState: .Normal)
                infoBtn.addTarget(self, action: "infoBtnClicked", forControlEvents: .TouchUpInside)
                bottomView.addSubview(infoBtn)
                let midSplit = UIView(frame: CGRectMake(len,0,1,85))
                midSplit.backgroundColor = UIColor.whiteColor()
                bottomView.addSubview(midSplit)
                deleteBtn = UIButton(frame: CGRectMake(len+1,0,len,85))
                deleteBtn.setImage(UIImage(named: "btn_chat_delete"), forState: .Normal)
                deleteBtn.addTarget(self, action: "deleteBtnClicked", forControlEvents: .TouchUpInside)
                bottomView.addSubview(deleteBtn)
            }else{
                bottomLen = SCREEN_WIDTH/2
                let len = (bottomLen-2)/3
                let frame = CGRectMake(SCREEN_WIDTH-bottomLen, 0, bottomLen, 85)
                bottomView.frame = frame
                infoBtn = UIButton(frame: CGRectMake(0,0,len,85))
                infoBtn.setImage(UIImage(named: "btn_chat_info"), forState: .Normal)
                infoBtn.addTarget(self, action: "infoBtnClicked", forControlEvents: .TouchUpInside)
                bottomView.addSubview(infoBtn)
                let leftSplit = UIView(frame: CGRectMake(len,34,1,17))
                leftSplit.backgroundColor = UIColor.whiteColor()
                bottomView.addSubview(leftSplit)
                midLockBtn = UIButton(frame: CGRectMake(len+1,0,len,85))
                midLockBtn!.setImage(UIImage(named: "btn_chat_lock_25"), forState: .Normal)
                midLockBtn!.addTarget(self, action: "midLockBtnClicked", forControlEvents: .TouchUpInside)
                bottomView.addSubview(midLockBtn!)
                let rightSplit = UIView(frame: CGRectMake(len*2+1,34,1,17))
                rightSplit.backgroundColor = UIColor.whiteColor()
                bottomView.addSubview(rightSplit)
                deleteBtn = UIButton(frame: CGRectMake((len+1)*2,0,len,85))
                deleteBtn.setImage(UIImage(named: "btn_chat_delete"), forState: .Normal)
                deleteBtn.addTarget(self, action: "deleteBtnClicked", forControlEvents: .TouchUpInside)
                bottomView.addSubview(deleteBtn)
            }
        }
    }
    var message = [SingleChatMessageFrame](){
        didSet{
            let msg = message.last
            if(msg != nil){
                if(msg!.chatMessage.messageType.rawValue == 1){
                    lastMessage.text = "[图片]"
                }else if(msg!.chatMessage.messageType.rawValue == 0){
                    lastMessage.text = msg!.chatMessage.MsgContent
                }else{
                    lastMessage.text = "[P币]"
                }
                timeLabel.text = "\(Tools.toDisplayTime((message.last?.chatMessage.MsgTime)!))"
            }
            else{
                timeLabel.text = "\(Tools.toDisplayTime(Tools.getSinceTime(NSDate())))"
                lastMessage.text = "[嘻嘻]快来和你的小伙伴聊天吧！"
            }
        }
    }
    
    var bottomLen:CGFloat = 0
    
    @IBOutlet weak var lockBtn: UIButton!
    @IBOutlet weak var headImage: UIButton!
    
    var bottomView:UIView!
    var deleteBtn:UIButton!
    var infoBtn:UIButton!
    var midLockBtn:UIButton?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.contentView.backgroundColor = COLOR_BG
        lockBtn.setImage(UIImage(named: "icon_chat_circle"), forState: UIControlState.Normal)
        lockBtn.addTarget(self, action: "lockBtnDidClicked", forControlEvents: .TouchUpInside)
        headImage.setImage(UIImage(named: "user_pic_radar"), forState: UIControlState.Normal)
        badgeView = JSBadgeView(parentView: headImage, alignment: .BottomLeft)
        nameLabel = UILabel()
        nameLabel.font = UIFont.systemFontOfSize(15)
        nameLabel.textColor = UIColor.orangeColor()
        dotView = UIImageView()
        splitLine = UIView(frame: CGRectMake(CGRectGetMaxX(headImage.frame), CGRectGetMaxY(headImage.frame)-1, SCREEN_WIDTH-90, 1))
        splitLine.backgroundColor = UIColor.whiteColor()
        splitLine.alpha = 0.6

        self.addSubview(splitLine)
        self.contentView.addSubview(dotView)
        self.contentView.addSubview(nameLabel)
        bottomView = UIView()
        bottomView.hidden = true
        bottomView.backgroundColor = UIColor.redColor()
        self.addSubview(bottomView)
        self.bringSubviewToFront(self.contentView)
        
        panG = UIPanGestureRecognizer(target: self, action: "pan:")
        panG.delegate = self
        self.addGestureRecognizer(panG)
    }
    
    func pan(gesture:UIPanGestureRecognizer){
        let currentTouchPoint = gesture.locationInView(self.contentView)
        let ctpX = currentTouchPoint.x
        let velocity = gesture.velocityInView(self.contentView)
        if(gesture.state == .Began){
            initialX = ctpX
            if(velocity.x > 0){
                //delegate will hidden
            }else{
                //delegate didShow
            }
        }else if (gesture.state == .Changed){
            let panAmount = ctpX - self.initialX
            self.initialX = ctpX
            let minOriginX:CGFloat = -bottomLen
            let maxOriginX:CGFloat = 0
            var originX = CGRectGetMinX(self.contentView.frame) + panAmount
            originX = maxOriginX < originX ? maxOriginX : originX
            originX = minOriginX > originX ? minOriginX : originX
            if(velocity.x < 0){
                menuIsShow = false
                self.bottomView.hidden = false
            }else{
                menuIsShow = true
            }
            self.contentView.frame = CGRectMake(originX, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds))
            
        }else if(gesture.state == .Ended || gesture.state == .Cancelled){
            endFrameChange()
        }
    }
    
    func endFrameChange(){
        let x:CGFloat = menuIsShow ? 0 : -bottomLen
        let frame = CGRectMake(x, 0, self.bounds.width, self.bounds.height)
        UIView.animateWithDuration(0.25, delay: 0, options: .BeginFromCurrentState, animations: { () -> Void in
            self.contentView.frame = frame
            }, completion: { (finishi) -> Void in

            })
        
    }

    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    class func loadFromNib() ->UserCell {
        return NSBundle.mainBundle().loadNibNamed("UserCell", owner: self, options: nil).last as! UserCell
    }
    
    func lockBtnDidClicked(){
        if(tenUser.isLocked){
            tenUser.isLocked = false
            lockBtn.setImage(UIImage(named: "icon_chat_circle"), forState: .Normal)
        }else{
            tenUser.isLocked = true
            lockBtn.setImage(UIImage(named: "icon_chat_lock_19"), forState: .Normal)
        }
    }
    
    func infoBtnClicked(){
        self.delegate?.menuInfoBtnDidClicked(self)
    }
    
    func deleteBtnClicked(){
        self.delegate?.menuDeleteBtnDidClicked(self)
    }
    
    func midLockBtnClicked(){
        self.delegate?.menuMidLockBtnDidClicked(self)
    }

}
