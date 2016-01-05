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
    
    override var chatFrame:SingleChatMessageFrame!{
        didSet{
            
            timeLabel.text = chatFrame.chatMessage.MsgTime
            content.text = chatFrame.chatMessage.attrMsg.string
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .None
        self.backgroundColor = UIColor(red: 236.0/255.0, green: 236.0/255.0, blue: 236.0/255.0, alpha: 1.0)
        lockBtn.setImage(UIImage(named:"btn_chat_lock_25"), forState: UIControlState.Normal)
        headImage.setImage(UIImage(named: "user_pic_88"), forState: UIControlState.Normal)
        context.titleLabel?.numberOfLines = 0
        let image = UIImage(named: "chat_recive_press_pic")
        let w = image!.size.width/2
        let h = image!.size.height/2
        let newImage = image?.resizableImageWithCapInsets(UIEdgeInsetsMake(h, w, h, w), resizingMode: UIImageResizingMode.Tile)
        context.setBackgroundImage(newImage, forState: UIControlState.Normal)
        // Initialization code
        self.lockBtn.setImage(UIImage(named: "icon_chat_circle"), forState: UIControlState.Normal)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
