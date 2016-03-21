//
//  MainGrid.swift
//  Ten
//
//  Created by Yumen Cao on 2/1/16.
//  Copyright © 2016 LiMao Tech. All rights reserved.
//

import UIKit
import SwiftyJSON


// boolean table

class TenMainGridManager: NSObject {
        
    static let SharedInstance = TenMainGridManager()

    var numToGen: Int = 0
    var nodes: [TenGridButton] = [TenGridButton]()
    var gridUsers: [AnyObject] = [AnyObject]()

    
    func clearNodes() {
        for node in nodes {
            node.removeFromSuperview()
        }
        nodes.removeAll()
    }
    
    func createButtons(gender: Int) -> [TenGridButton] {
        if gender == 2 {
            gridUsers = TenOtherUsersJSONManager.SharedInstance.selectGridUsers()
        }
        else {
            gridUsers = TenOtherUsersJSONManager.SharedInstance.selectGridUsersByGender(gender)
        }

        numToGen = gridUsers.count
        
        for i in 0..<numToGen {

            let xIncre = CGFloat(drand48()+0.1)*SCREEN_WIDTH/7
            let yIncre = CGFloat(drand48()+0.1)*SCREEN_HEIGHT/13

            let spot = CGPointMake(grid2[i].0*SCREEN_WIDTH+xIncre, grid2[i].1*SCREEN_HEIGHT+yIncre)
            
            let node = TenGridButton(frame: CGRectMake(spot.x, spot.y, SCREEN_WIDTH/20, SCREEN_WIDTH/20))
            node.layer.cornerRadius = SCREEN_WIDTH/40
            
            nodes.append(node)
            node.tenUserDict = gridUsers[i] as! [String : AnyObject]
            
            let userJSON = JSON(node.tenUserDict)
            if userJSON["Gender"].intValue == 0 {
                node.backgroundColor = COLOR_MALE
            }
            else {
                node.backgroundColor = COLOR_FEMALE
            }
            
            node.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.001, 0.001)
        }

        return nodes
    }

    private let grid2: [(CGFloat, CGFloat)] = [
        // center
        (1/6,4/9),             (3/5,4/9),
        (1/5,3/9), (2/5,3/11), (3/5,3/9),
        (1/5,5/9), (2/5,5/9),  (3/5,5/9),
        (1/5,2/9), (2/5,2/11), (3/5,2/9),
        (1/5,6/9), (2/5,6/9),  (3/5,6/9),

        // edges
        (0,4/9),  (4/5,4/9),
        (0,3/9),  (4/5,3/9),
        (0,5/9),  (4/5,5/9),
        (0,2/9),  (4/5,2/9),
        (0,6/9),  (4/5,6/9),
    ]
}