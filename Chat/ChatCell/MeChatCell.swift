//
//  MeChatCell.swift
//  swiftChat
//
//  Created by gt on 15/9/12.
//  Copyright (c) 2015年 gt. All rights reserved.
//

import UIKit

class MeChatCell: ChatBaseCell {
    @IBOutlet weak var conText: UILabel!
    @IBOutlet weak var lockBtn: UIButton!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var content: UIButton!
    @IBOutlet weak var textView: UIView!
    override var chatFrame:SingleChatMessageFrame!{
        didSet{
            
            if(chatFrame.chatMessage.messageType == .Image){
                conText.text = ""
                time.text = ""
                content.imageEdgeInsets = UIEdgeInsets.init(top: 8, left: 0, bottom: 18, right: 3)
                content.setImage(chatFrame.chatMessage.MsgImage!, forState: .Normal)
            }else{
                conText.attributedText = chatFrame.chatMessage.attrMsg
                time.text = chatFrame.chatMessage.MsgTime
                
            }
            if(MsgIsLock){
                lockBtn.setImage(UIImage(named: "icon_chat_lock_19"), forState: .Normal)
            }
            let image = UIImage(named: "chat_send_nor")
            let w = image!.size.width/2
            let h = image!.size.height/2
            let newImage = image?.resizableImageWithCapInsets(UIEdgeInsetsMake(h, w, h, w), resizingMode: UIImageResizingMode.Tile)
            content.setBackgroundImage(newImage, forState: UIControlState.Normal)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .None
        self.content.enabled = false
        self.content.adjustsImageWhenDisabled = false
        self.backgroundColor = UIColor(red: 236.0/255.0, green: 236.0/255.0, blue: 236.0/255.0, alpha: 1.0)
        self.textView.backgroundColor = UIColor.clearColor()
        content.titleLabel?.numberOfLines = 0
        self.lockBtn.setImage(UIImage(named: "icon_chat_circle"), forState: UIControlState.Normal)
        lockBtn.addTarget(self, action: "lockBtnClicked", forControlEvents: .TouchUpInside)
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func lockBtnClicked(){
        if(MsgIsLock){
            lockBtn.setImage(UIImage(named: "icon_chat_circle"), forState: UIControlState.Normal)
        }else{
            lockBtn.setImage(UIImage(named: "icon_chat_lock_19"), forState: .Normal)
        }
        MsgIsLock = !MsgIsLock
        self.delegate?.unlockBtnClicked(self)
    }
    
}
