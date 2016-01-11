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
    var Birthday : String = ""
    var JoinedDate : String = ""
    var PCoin : Double = 0
    var OuterScore : Int = 0{
        didSet{
         Average = (OuterScore+InnerScore)/2
        }
    }
    var InnerScore : Int = 0{
        didSet{
            Average = (OuterScore+InnerScore)/2
        }
    }
    var Energy : Int = 0
    var Hobby : String = ""
    var Quote : String = ""
    var Lati : Double = -1
    var Longi : Double = -1
    var ProfileUrl = ""
    var Average = 0
    var listType = chatType.InActive
    
    var Portrait:NSData?{
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
    
    func ValueWithDict(dict:[String : AnyObject]){
        self.setValuesForKeysWithDictionary(dict)
    }
    
    func updateCoordinates(lati : Double, longi : Double) -> Bool {
        self.Lati = lati
        self.Longi = longi
        return true
    }
    
}
