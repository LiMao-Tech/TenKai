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
    var PurchaseDate = 3
    var ModifiedDate = 4
    var Content = 0
    var Status = ""
    var PurchaseType = 0
    
    init(dict :NSDictionary) {
        super.init()
        self.setValuesForKeysWithDictionary(dict as! [String : AnyObject])
    }

}
