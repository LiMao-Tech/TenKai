//
//  SharedUser.swift
//  Ten
//
//  Created by gt on 15/12/22.
//  Copyright © 2015年 LiMao Tech. All rights reserved.
//

import UIKit

class SharedUser : NSObject {
    static let sharedUser = SharedUser()
    var UserIndex : Int = 0
    var UserName : String = ""
    var PhoneType : Int = 0
    var Gender : Int = -1
    var Marriage: Int = -1
    var Birthday : String = ""
    var JoinedDate : String = ""
    var PCoin : Double = 0
    var OuterScore : Int = 0
    var InnerScore : Int = 0
    var Energy : Int = 0
    var Hobby : String = ""
    var Quote : String = ""
    var Lati : Double = -1
    var Longi : Double = -1
    var ProfileUrl = ""
    var Average = 0
    
    var Portrait : NSData?
    
    override init() {
        super.init()
    }
    
    init(dict:[String : AnyObject]) {
        super.init()
        self.ValueWithDict(dict)
    }
    
    func ValueWithDict(dict:[String : AnyObject]){
        self.setValuesForKeysWithDictionary(dict)
        self.Average = (self.InnerScore + self.OuterScore)/2
    }
    
    func updateCoordinates(lati : Double, longi : Double) -> Bool {
        self.Lati = lati
        self.Longi = longi
        return true
    }

    
    class func StandardUser() -> SharedUser{
        return sharedUser
    }
    
    class func changeValue(dict:[String:AnyObject]){
        sharedUser.setValuesForKeysWithDictionary(dict)
    }
}
