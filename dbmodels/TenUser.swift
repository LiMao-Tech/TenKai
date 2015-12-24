//
//  TenUserModel.swift
//  Ten
//
//  Created by Yifang Zhang on 10/12/15.
//  Copyright © 2015 LiMao Tech. All rights reserved.
//  Heavily Modified by Yumen Tsao on 11/01/15.

/*
Note: This model follows c sharp naming convention since is used with ASP .Net
Backend.
*/

class TenUser: NSObject {
    var UserIndex : Int = 0
    var UserName : String = ""
    var PhoneType : Int = 0
    var Gender : Int = 0
    var Marriage: Int = 0
    var Birthday : String = ""
    var JoinedDate : String = ""
    var PCoin : Double = 1
    var OuterScore : Int = 0
    var InnerScore : Int = 0
    var Energy : Int = 0
    var Hobby : String = ""
    var Quote : String = ""
    var Lati : Double = -1
    var Longi : Double = -1
    var ProfileUrl = ""
    var Average = 0
    
    var Portrait = NSData()

    
//    init(userName : String, gender : Int8, birthday : NSDate, joinedDate : NSDate,
//        pCoin : Double, outerScore : Int, innerScore : Int, energy : Int) {
//            self.UserName = userName
//            self.Gender = gender
//            self.Birthday = birthday
//            self.JoinedDate = joinedDate
//            self.PCoin = pCoin
//            self.OuterScore = outerScore
//            self.InnerScore = innerScore
//            self.Energy = energy
//    }
    
    override init() {
        super.init()
    }
    
    init(loginDict:[String : AnyObject]) {
        super.init()
        self.initWithDict(loginDict)
    }
    
    func initWithDict(loginDict:[String : AnyObject]){
        self.setValuesForKeysWithDictionary(loginDict)
    }
    
    func updateCoordinates(lati : Double, longi : Double) -> Bool {
        self.Lati = lati
        self.Longi = longi
        return true
    }
}
