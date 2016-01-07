//
//  NotificationFrame.swift
//  Ten
//
//  Created by gt on 15/10/12.
//  Copyright © 2015年 LiMao Tech. All rights reserved.
//

import UIKit

class NotificationFrame: NSObject {
    
    var titleFrame = CGRectMake(10, 10, SCREEN_WIDTH - 110, 20)
    var detailFrame:CGRect!
    var timeFrame = CGRectMake(SCREEN_WIDTH - 100, 10, 90, 20)
    var cellheight:CGFloat!
    var splitFrame:CGRect!
    
    var notification:Notification!{
        didSet{
            let size = CGSizeMake(SCREEN_WIDTH - 20, CGFloat(MAXFLOAT))
            let frame = notification.MsgContent.boundingRectWithSize(size, options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName:UIFont.systemFontOfSize(15)], context: nil)
            detailFrame = CGRectMake(10, 40,frame.width , frame.height)
            cellheight = 50 + detailFrame.height
            splitFrame = CGRectMake(0, cellheight - 1, SCREEN_WIDTH, 1)
        }
    }
}