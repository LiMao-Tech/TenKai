//
//  BaseUser.swift
//  Ten
//
//  Created by gt on 16/1/4.
//  Copyright © 2016年 LiMao Tech. All rights reserved.
//

import UIKit

class TenUser: NSObject {
    
    var UserIndex : Int = 0
    var UserName : String = ""
    var PhoneType : Int = 0
    var Gender : Int = -1
    var Marriage: Int = -1
    
    var Birthday : NSTimeInterval = 0
    var JoinedDate : NSTimeInterval = 0
    
    var PCoin : Double = 0
    var OuterScore : Int = 0
    var InnerScore : Int = 0
    var Energy : Int = 0
    var Hobby : String = ""
    var Quote : String = ""
    var Lati : Double = -1
    var Longi : Double = -1
    var ProfileUrl = ""
    
    //mobile end properties
    
    var isRatered = false
    
    var Average :Int {
        get{
            return (self.OuterScore+self.InnerScore)/2
        }
    }
    
    var Expire = 0
    
    var AVG:Int = 0 {
        didSet{
            if(Tools.getSinceTime(NSDate()) > self.Expire){
                AVG = self.Average
            }
        }
    }
    var listType = chatType.InActive
    
    var Portrait = UIImagePNGRepresentation(UIImage(named: "user_pic_radar_140")!) {
        didSet{
            PortraitImage = UIImage(data: Portrait!)
        }
    }
    var PortraitImage:UIImage?
    
    override init() {
        super.init()
    }
    
    init(dict:[String : AnyObject]) {
        super.init()
        self.ValueWithDict(dict)
    }
    
    // this needs to be explicit
    func ValueWithDict(dict:[String : AnyObject]) {
        self.setValuesForKeysWithDictionary(dict)
        if(Tools.getSinceTime(NSDate()) > self.Expire){
            AVG = self.Average
        }
    }
    
    func updateCoordinates(lati : Double, longi : Double) -> Bool {
        self.Lati = lati
        self.Longi = longi
        return true
    }
}
