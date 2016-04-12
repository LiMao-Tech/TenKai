//
//  BaseUser.swift
//  Ten
//
//  Created by gt on 16/1/4.
//  Copyright © 2016年 LiMao Tech. All rights reserved.
//

import UIKit
import CoreLocation

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
    
    var GesturePin = ""
    var DevicePin = 0
    
    //mobile end properties
    
    var isRatered = false
    var isLocked = false
    
    var distance : String = ""
    var Average :Int {
        get{
            if(Int(Tools.getSinceTime(NSDate())) > self.Expire){
                return (self.OuterScore+self.InnerScore)/2
            }
            return AVG
        }
    }
    
    var Expire = 0
    
    var AVG: Int = 0
    
    var listType = chatType.InActive
    
    var Portrait = UIImagePNGRepresentation(UIImage(named: "user_pic_radar")!) {
        didSet{
            PortraitImage = UIImage(data: Portrait!)
        }
    }
    var PortraitImage:UIImage?
    
    var badgeNum = 0
    
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
        self.distance = getDistance()
        
    }
    
    func updateCoordinates(lati : Double, longi : Double) -> Bool {
        self.Lati = lati
        self.Longi = longi
        return true
    }
    
    func getDistance() -> String{
        let loc = CLLocation(latitude: Lati, longitude: Longi)
        if loc.altitude == 0 && loc.coordinate.longitude == 0 {
            return "??"
        }
        else if let distDouble = LOC_MANAGER.location?.distanceFromLocation(loc) {
            if distDouble > 1000 {
                let dist = String(Int(distDouble/1000))
                return "\(dist) kM"
            }
            else {
                let dist = String(Int(distDouble))
                return "\(dist) m"
            }
        }
        return "??"
    }
}
