//
//  Tools.swift
//  Ten
//
//  Created by gt on 15/12/1.
//  Copyright © 2015年 LiMao Tech. All rights reserved.
//

import Foundation

class Tools : NSObject{
    
    class func getNormalTime(date:NSDate) -> String{
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.stringFromDate(date)
    }
    
    class func formatStringTime(time: String) -> String{
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss +0000"
        return Tools.getNormalTime(formatter.dateFromString(time)!)
    }
    
    class func getFileNameTime(date:NSDate) -> String{
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyyMMddHHmmss"
        return formatter.stringFromDate(date)
    }
}
