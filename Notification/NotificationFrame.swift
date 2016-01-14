//
//  NotificationFrame.swift
//  Ten
//
//  Created by gt on 15/10/12.
//  Copyright © 2015年 LiMao Tech. All rights reserved.
//

import UIKit

class NotificationFrame: NSObject {
    
    let titleFrame = CGRectMake(5, 10, SCREEN_WIDTH - 110, 20)
    var detailFrame:CGRect!
    let timeFrame = CGRectMake(SCREEN_WIDTH-120, 10, 95, 20)
    var cellheight:CGFloat!
    var splitFrame:CGRect!
    
    var notification:Notification!{
        didSet{
            let size = CGSizeMake(SCREEN_WIDTH - 20, CGFloat(MAXFLOAT))
            let frame = notification.MsgContent.boundingRectWithSize(size, options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName:UIFont.systemFontOfSize(15)], context: nil)
            detailFrame = CGRectMake(10, 40,SCREEN_WIDTH-20 , frame.height)
            cellheight = 50 + detailFrame.height
            splitFrame = CGRectMake(0, cellheight - 1, SCREEN_WIDTH, 1)
        }
    }
}