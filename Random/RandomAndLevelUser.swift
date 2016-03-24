//
//  RandomAndLevelUser.swift
//  Ten
//
//  Created by gt on 15/10/12.
//  Copyright © 2015年 LiMao Tech. All rights reserved.
//

import UIKit

/*
TODO: This class needs to be revised, since the declaration is rather simple
and I believe that it can be merged with TenUser. It is expensive to keep two
arrays with similar objects.
*/

class RandomAndLevelUser: TenUser {
    var distance = 0
    
    override init(dict: [String : AnyObject]) {
        super.init(dict: dict)
    }
}
