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
        Formatter.dateFormat = "yyyy/MM/dd"
        return Formatter.stringFromDate(date)
    }
    
    class func getTimeInDay(date:NSDate) -> String{
        Formatter.dateFormat = "HH:mm"
        return Formatter.stringFromDate(date)
    }
    class func getTimeInMonth(date:NSDate) -> String{
        Formatter.dateFormat = "MM月dd日"
        return Formatter.stringFromDate(date)
    }
    
    class func getSinceTime(date:NSDate) -> Int{
        return Int(date.timeIntervalSince1970)
    }
    
    class func formatStringTime(time: String) -> String{
        Formatter.dateFormat = "yyyy-MM-dd HH:mm:ss +0000"
        return Tools.getNormalTime(Formatter.dateFromString(time)!)
    }
    
    class func getFileNameTime(date:NSDate) -> String{
        Formatter.dateFormat = "yyyyMMddHHmmss"
        return Formatter.stringFromDate(date)
    }
    
    class func longToDate(time:Int) -> NSDate{
        let timeInterval = Double(time)
        let timeDate = NSDate(timeIntervalSince1970: timeInterval)
        return timeDate
    }
    
    class func toDisplayTime(time:Int) -> String{
        var disPlayTime = ""
        let calendar = NSCalendar.currentCalendar()
        let transTime = NSDate(timeIntervalSince1970: Double(time))
        let compsnow = calendar.components([.Year,.Month,.Day,.Hour,.Minute], fromDate: NSDate())
        let compsTrans = calendar.components([.Year,.Month,.Day,.Hour,.Minute], fromDate: NSDate())
        if(compsTrans.year == compsnow.year){
            if(compsTrans.month == compsnow.month){
                if(compsTrans.day == compsnow.day){
                    disPlayTime = getTimeInDay(transTime)
                }
                else{
                    if(compsTrans.day + 1 == compsnow.day){
                        disPlayTime = "昨天"
                    }else{
                        disPlayTime = getTimeInMonth(transTime)
                    }
                }
            }
            else{
                disPlayTime = getNormalTime(transTime)
            }
        }else{
            disPlayTime = getNormalTime(transTime)
        }
        
        return disPlayTime
    }
    
    // string转attributeString
    class func stringToAttributeString(matchString:String) -> (text:NSMutableAttributedString,isString:Bool) {
        let Str:NSString = matchString as NSString
        var isString = true
        let pattern = "\\[\\d{3}\\]"
        var text = NSMutableAttributedString(string: matchString)
        var array = Array<NSTextCheckingResult>()
        let expression=try! NSRegularExpression(pattern: pattern, options: NSRegularExpressionOptions.CaseInsensitive)
        expression.enumerateMatchesInString(matchString, options: NSMatchingOptions.ReportCompletion, range: NSMakeRange(0, matchString.characters.count)) { (result, flag, stop) -> Void in
            if((result) != nil){
                array.append(result!)
            }
        }
        
        if(array.count > 0){
            isString = false
            let len = text.length - (array[array.count-1].range.location + array[array.count-1].range.length)
            for(var i = array.count - 1; i >= 0; i--){
                let attr = NSMutableAttributedString(attributedString: text)
                let temp = Str.substringWithRange((array[i].range)) as NSString
                let temp0 = attr.attributedSubstringFromRange(NSMakeRange(0, array[i].range.location))
                let location1 = array[i].range.location + array[i].range.length
                let len1 = attr.length - location1
                let temp1 = attr.attributedSubstringFromRange(NSMakeRange(location1, len1))
                if(faceCodes.containsObject(temp)){
                    let attachment = GTTextAttachment()
                    attachment.image = UIImage(named:temp.substringWithRange(NSMakeRange(1, 3)) as String)
                    attachment.faceCode = temp
                    let attStr = NSAttributedString(attachment: attachment)
                    attr.setAttributedString(NSAttributedString(string: ""))
                    attr.appendAttributedString(temp0)
                    attr.setAttributes([NSFontAttributeName: UIFont.systemFontOfSize(15)], range: NSMakeRange(0, temp0.length))
                    attr.appendAttributedString(attStr)
                    attr.appendAttributedString(temp1)
                    attr.setAttributes([NSFontAttributeName: UIFont.systemFontOfSize(15)], range: NSMakeRange(attr.length-len,len))
                    text = attr
                }
            }
        }
        return (text,isString)
    }
    
    //circlur image
    class func toCirclurImage(aImage:UIImage) -> UIImage{
        let image = Tools().toFixSize(aImage)
//        let image = aImage
        UIGraphicsBeginImageContext(image.size)
        let context = UIGraphicsGetCurrentContext()
        CGContextAddArc(context, image.size.width/2, image.size.height/2, image.size.width/2, 0, CGFloat(M_PI*2), 0)
        CGContextClip(context)
        let rect = CGRectMake(0, 0, image.size.width, image.size.height)
        image.drawInRect(rect)
        CGContextAddEllipseInRect(context, rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    private func toFixSize(image:UIImage) -> UIImage{
        let l:CGFloat = 140
        UIGraphicsBeginImageContext(CGSizeMake(l, l))
        image.drawInRect(CGRectMake(0, 0, l, l))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    /*
    + (NSData *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize
    {
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return UIImageJPEGRepresentation(newImage, 0.8);
    }
    */
    
}
