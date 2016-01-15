//
//  PCoinCell.swift
//  Ten
//
//  Created by gt on 16/1/15.
//  Copyright © 2016年 LiMao Tech. All rights reserved.
//

import UIKit

class PCoinCell: ChatBaseCell {
    @IBOutlet weak var content: UILabel!
    override var chatFrame:SingleChatMessageFrame!{
        didSet{
            let msg = chatFrame.chatMessage
            if(msg.belongType == .Me){
                content.text = "送出 "+msg.MsgContent+" P币"
            }else{
                content.text = "收到 "+msg.MsgContent+" P币"
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        content.layer.cornerRadius = 5
        content.layer.masksToBounds = true
        self.backgroundColor = UIColor(red: 236.0/255.0, green: 236.0/255.0, blue: 236.0/255.0, alpha: 1.0)
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
