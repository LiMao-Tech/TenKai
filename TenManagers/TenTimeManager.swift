//
//  TenTimeManager.swift
//  Ten
//
//  Created by Yumen Cao on 2/7/16.
//  Copyright © 2016 LiMao Tech. All rights reserved.
//

import UIKit

class TenTimeManager: NSObject {

    static let SharedInstance = TenTimeManager()

    let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)

    func getAge(birthday: NSDate) -> Int {
        let components = calendar!.components(.Year, fromDate: birthday, toDate: NSDate(), options: .MatchFirst)
        return components.year
    }
}
