//
//  PCoinHistoryModel.swift
//  Ten
//
//  Created by gt on 16/2/22.
//  Copyright © 2016年 LiMao Tech. All rights reserved.
//

import UIKit

class PCoinHistoryModel: NSObject {
    var ID = 1
    var UserId = ""
    var PurchaseDate:NSTimeInterval = 3
    var ModifiedDate:NSTimeInterval = 4
    var Content = ""
    var Status = ""
    var PurchaseType = 0
    var Note = ""
    var Balance = 0
    
    override init() {
        super.init()
    }
    
    init(dict :NSDictionary) {
        super.init()
        self.setValuesForKeysWithDictionary(dict as! [String : AnyObject])
    }

}
