//
//  Tools.swift
//  Ten
//
//  Created by gt on 15/12/1.
//  Copyright © 2015年 LiMao Tech. All rights reserved.
//

import Foundation



class Tools : NSObject{
    
    static let Formatter = NSDateFormatter()
    
    class func getNormalTime(date:NSDate) -> String{
        Formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return Formatter.stringFromDate(date)
    }
    
    class func formatStringTime(time: String) -> String{
        Formatter.dateFormat = "yyyy-MM-dd HH:mm:ss +0000"
        return Tools.getNormalTime(Formatter.dateFromString(time)!)
    }
    
    class func getFileNameTime(date:NSDate) -> String{
        Formatter.dateFormat = "yyyyMMddHHmmss"
        return Formatter.stringFromDate(date)
    }
    
}
