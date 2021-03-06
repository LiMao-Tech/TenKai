//
//  OtherChatCell.swift
//  swiftChat
//
//  Created by gt on 15/9/12.
//  Copyright (c) 2015年 gt. All rights reserved.
//

import UIKit

class OtherChatCell: ChatBaseCell {

    @IBOutlet weak var lockBtn: UIButton!
    
    @IBOutlet weak var headImage: UIButton!
    @IBOutlet weak var context: UIButton!
    @IBOutlet weak var content: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    override var tenUser:TenUser!{
        didSet{
            var image:UIImage!
            if(tenUser.PortraitImage != nil){
                image = Tools.toCirclurImage(tenUser.PortraitImage!)
            }else{
                image = UIImage(named: "user_pic")
            }
            headImage.setImage(image, forState: .Normal)
        }
    }
    override var chatFrame:SingleChatMessageFrame!{
        didSet{
            context.setImage(nil, forState: .Normal)
            if(chatFrame.chatMessage.messageType == .Image){
                content.text = ""
                timeLabel.text = ""
                context.imageEdgeInsets = UIEdgeInsets.init(top: 8, left: 3, bottom: 18, right: 0)
                context.setImage(chatFrame.chatMessage.MsgImage!, forState: .Normal)
            }else{
                if(chatFrame.chatMessage.isString){
                    content.text = chatFrame.chatMessage.MsgContent
                }else{
                    content.attributedText = chatFrame.chatMessage.attrMsg
                }
                
                timeLabel.text = "\(Tools.toDisplayTime(chatFrame.chatMessage.MsgTime))"
                
            }
            if(chatFrame.chatMessage.IsLocked){
                lockBtn.setImage(UIImage(named: "icon_chat_lock_19"), forState: .Normal)
            }else{
                lockBtn.setImage(UIImage(named: "icon_chat_circle"), forState: UIControlState.Normal)
            }
            let image = UIImage(named: "chat_recive_press_pic")
            let w = image!.size.width/2
            let h = image!.size.height/2
            let newImage = image?.resizableImageWithCapInsets(UIEdgeInsetsMake(h, w, h, w), resizingMode: UIImageResizingMode.Tile)
            context.setBackgroundImage(newImage, forState: UIControlState.Normal)
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .None
        self.backgroundColor = UIColor(red: 236.0/255.0, green: 236.0/255.0, blue: 236.0/255.0, alpha: 1.0)
        headImage.setImage(UIImage(named: "user_pic"), forState: UIControlState.Normal)
        context.titleLabel?.numberOfLines = 0
                // Initialization code
        self.lockBtn.setImage(UIImage(named: "icon_chat_circle"), forState: UIControlState.Normal)
        lockBtn.addTarget(self, action: #selector(OtherChatCell.lockBtnClicked), forControlEvents: .TouchUpInside)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func lockBtnClicked(){
        if(chatFrame.chatMessage.IsLocked){
            lockBtn.setImage(UIImage(named: "icon_chat_circle"), forState: UIControlState.Normal)
        }else{
            lockBtn.setImage(UIImage(named: "icon_chat_lock_19"), forState: .Normal)
        }
        chatFrame.chatMessage.IsLocked = !chatFrame.chatMessage.IsLocked
        self.delegate?.unlockBtnClicked(self)
    }
}
