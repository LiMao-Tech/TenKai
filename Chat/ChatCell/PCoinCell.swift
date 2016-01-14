//
//  PCoinCell.swift
//  Ten
//
//  Created by gt on 16/1/14.
//  Copyright © 2016年 LiMao Tech. All rights reserved.
//

import UIKit

class PCoinCell: ChatBaseCell {
    var pcoinLabel:UILabel!
    var message = SingleChatMessageFrame(){
        didSet{
            if(message.chatMessage.belongType == .Me){
                pcoinLabel.text = "送出 "+message.chatMessage.MsgContent+" P币"
            }else{
                pcoinLabel.text = "收到 "+message.chatMessage.MsgContent+" P币"
            }
        }
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        pcoinLabel = UILabel(frame: CGRectMake(30,10,SCREEN_WIDTH-60,20))
        pcoinLabel.backgroundColor = UIColor.whiteColor()
        pcoinLabel.textColor = BG_COLOR
        self.addSubview(pcoinLabel)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
