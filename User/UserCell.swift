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
        
        let lableText:NSString = "userName"
        let w = SCREEN_WIDTH - 190
        let attr = [NSFontAttributeName:UIFont.systemFontOfSize(17)]
        let size = lableText.boundingRectWithSize(CGSizeMake(w, 21), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: attr, context: nil)
        
        nameLabel = UILabel(frame: CGRectMake(CGRectGetMaxX(headImage.frame)+5, headImage.frame.origin.y, size.width, 21))
        nameLabel.text = lableText as String
        nameLabel.textColor = UIColor.orangeColor()
        let x = CGRectGetMaxX(nameLabel.frame)
        dotView = UIImageView(frame: CGRectMake(x+10, nameLabel.frame.origin.y+7, 7, 7))
        dotView.image = UIImage(named: "icon_chat_dot_l6")
        
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
