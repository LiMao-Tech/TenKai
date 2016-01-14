//
//  NotificationInfoCell.swift
//  Ten
//
//  Created by gt on 15/10/12.
//  Copyright © 2015年 LiMao Tech. All rights reserved.
//

import UIKit

class NotificationInfoCell: UITableViewCell {
    var titleLable:UILabel!
    var timeLabel:UILabel!
    var detailLabel:UILabel!
    var splitLine:UIView!
    var notificationFrame:NotificationFrame!{
        didSet{
            titleLable.frame = notificationFrame.titleFrame
            timeLabel.frame = notificationFrame.timeFrame
            detailLabel.frame = notificationFrame.detailFrame
            splitLine.frame = notificationFrame.splitFrame
            splitLine.backgroundColor = UIColor.whiteColor()
            titleLable.font = UIFont(name: "PTSans", size: 17)
            titleLable.textColor = UIColor.orangeColor()
            timeLabel.font = UIFont(name: "PTSans", size: 13)
            timeLabel.textColor = UIColor.whiteColor()
            timeLabel.textAlignment = .Right
            detailLabel.font = UIFont(name: "PTSans", size: 15)
            detailLabel.textColor = UIColor.whiteColor()
            detailLabel.numberOfLines = 0
            titleLable.text = notificationFrame.notification.title
            timeLabel.text = notificationFrame.notification.MsgTime + " am"
            detailLabel.text = notificationFrame.notification.MsgContent as String
            self.addSubview(timeLabel)
            self.addSubview(detailLabel)
            self.addSubview(titleLable)
            self.addSubview(splitLine)
            self.backgroundColor = UIColor.clearColor()
            }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor  = UIColor.blackColor()
        titleLable = UILabel()
        timeLabel = UILabel()
        detailLabel = UILabel()
        splitLine = UILabel ()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
