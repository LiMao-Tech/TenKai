//
//  SharedUser.swift
//  Ten
//
//  Created by gt on 15/12/22.
//  Copyright © 2015年 LiMao Tech. All rights reserved.
//

import UIKit

class SharedUser: TenUser {
    static let sharedUser = SharedUser()
    class func getSharedUser() -> SharedUser{
        return sharedUser
    }
    override init() {
        super.init()
    }
}
