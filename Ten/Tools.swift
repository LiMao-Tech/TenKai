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
    class func toCirclurImage(image:UIImage,inset:CGFloat) -> UIImage{
        UIGraphicsBeginImageContext(image.size)
        let context = UIGraphicsGetCurrentContext()
        CGContextSetLineWidth(context, 2)
        CGContextSetStrokeColorWithColor(context, BG_COLOR.CGColor)
        let rect = CGRectMake(inset, inset, image.size.height-inset*2.0, image.size.height-inset*2.0)
        CGContextAddEllipseInRect(context, rect)
        CGContextClip(context)
        
        image.drawInRect(rect)
        CGContextAddEllipseInRect(context, rect)
        CGContextStrokePath(context)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}
