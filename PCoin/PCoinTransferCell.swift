//
//  PCoinTransferCell.swift
//  Ten
//
//  Created by gt on 15/10/18.
//  Copyright © 2015年 LiMao Tech. All rights reserved.
//

import UIKit

class PCoinTransferCell: UITableViewCell {
    var headImage:UIButton!
    var transferLabel:UILabel!
    var timeLabel:UILabel!
    var splitLine:UIView!
    var transfer:PCoinTransModel!{
        didSet{
            let info = transfer.MsgContent as NSString
            let size = info.boundingRectWithSize(CGSizeMake(SCREEN_WIDTH-80, CGFloat(MAXFLOAT)), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName:UIFont.systemFontOfSize(17)], context: nil)
            transferLabel = UILabel(frame: CGRectMake(70, 10, SCREEN_WIDTH-80, size.height))
            transferLabel.font = UIFont.systemFontOfSize(17)
            transferLabel.textColor = UIColor.orangeColor()
            transferLabel.numberOfLines = 0
            transferLabel.text = info as String
            timeLabel.text = Tools.toDisplayTime(transfer.MsgTime)
            self.addSubview(transferLabel)
            if(transfer.belongType == .Me){
                headImage.setImage(SHARED_USER.PortraitImage, forState: .Normal)
            }else{
                let targetUrl = Url_GetHeadImage+"\(transfer.Sender)"
                ALAMO_MANAGER.request(.GET, targetUrl).responseImage { response in
                    if let image = response.result.value {
                        self.headImage.setImage(Tools.toCirclurImage(image), forState: .Normal)
                    }
                }
            }
            
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        headImage = UIButton(frame: CGRectMake(10, 10, 55, 55))
        headImage.setImage(UIImage(named: "user_pic_110"), forState: .Normal)
        headImage.enabled = false
        headImage.adjustsImageWhenDisabled = false
        timeLabel = UILabel(frame: CGRectMake(70, 55, SCREEN_WIDTH-80, 15))
        timeLabel.font = UIFont.systemFontOfSize(13)
        timeLabel.textColor = UIColor.whiteColor()
        splitLine = UIView(frame: CGRectMake(65, 74, SCREEN_WIDTH-65, 1))
        splitLine.backgroundColor = UIColor.whiteColor()
        
        self.addSubview(headImage)
        self.addSubview(timeLabel)
        self.addSubview(splitLine)
        
        self.backgroundColor = UIColor.clearColor()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}
