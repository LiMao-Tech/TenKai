//
//  SharedUser.swift
//  Ten
//
//  Created by gt on 15/12/22.
//  Copyright © 2015年 LiMao Tech. All rights reserved.
//

import UIKit

class SharedUser: TenUser {
    
    var MsgIndex = 1{
        didSet{
            if(oldValue > MsgIndex){
                MsgIndex = oldValue
            }
        }
    }
    
    static let SharedInstance = SharedUser()
    
//    class func changeValue(dict:[String:AnyObject]){
//        SharedInstance.setValuesForKeysWithDictionary(dict)
//    }
}
