//
//  UserCell.swift
//  Ten
//
//  Created by gt on 15/10/18.
//  Copyright © 2015年 LiMao Tech. All rights reserved.
//

import UIKit

class UserCell: UITableViewCell {
    var nameLabel:UILabel!
    var dotView:UIImageView!
    var splitLine:UIView!
    @IBOutlet weak var lastMessage: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    var tenUser = TenUser(){
        didSet{
            nameLabel.text = tenUser.UserName
            message = UserChatModel.allChats().message[tenUser.UserIndex]!
            let w = SCREEN_WIDTH - 190
            let attr = [NSFontAttributeName:UIFont.systemFontOfSize(15)]
            let size = tenUser.UserName.boundingRectWithSize(CGSizeMake(w, 21), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: attr, context: nil)
            nameLabel.frame = CGRectMake(CGRectGetMaxX(headImage.frame)+5, headImage.frame.origin.y, size.width, 21)
            nameLabel.text = tenUser.UserName
            nameLabel.textColor = UIColor.orangeColor()
            let x = CGRectGetMaxX(nameLabel.frame)
            dotView.frame =  CGRectMake(x+10, nameLabel.frame.origin.y+7, 7, 7)
            dotView.image = UIImage(named: "icon_chat_dot_l6")
            headImage.setImage(tenUser.PortraitImage, forState: .Normal)
        }
    }
    var message = [SingleChatMessageFrame](){
        didSet{
            lastMessage.text = message.last?.chatMessage.MsgContent
            timeLabel.text = message.last?.chatMessage.MsgTime
        }
    }
    @IBOutlet weak var lockBtn: UIButton!
    @IBOutlet weak var headImage: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = UIColor.clearColor()
        lockBtn.setImage(UIImage(named: "icon_chat_circle"), forState: UIControlState.Normal)
        headImage.setImage(UIImage(named: "user_pic_radar_140"), forState: UIControlState.Normal)
        nameLabel = UILabel()
        nameLabel.font = UIFont.systemFontOfSize(15)
        nameLabel.textColor = UIColor.orangeColor()
        dotView = UIImageView()
        splitLine = UIView(frame: CGRectMake(CGRectGetMaxX(headImage.frame), CGRectGetMaxY(headImage.frame)-1, SCREEN_WIDTH-90, 1))
        splitLine.backgroundColor = UIColor.whiteColor()
        splitLine.alpha = 0.6

        self.addSubview(splitLine)
        self.addSubview(dotView)
        self.addSubview(nameLabel)
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    class func loadFromNib() ->UserCell {
        return NSBundle.mainBundle().loadNibNamed("UserCell", owner: self, options: nil).last as! UserCell
    }

}
