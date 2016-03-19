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

    private let minDiff: CGFloat = 15
    private let radiusSQ: CGFloat = (SCREEN_WIDTH*2/5)*(SCREEN_WIDTH*2/5)
    private let profileIconRadius: CGFloat = 70

    var numToGen: Int = 0
    var nodes: [TenGridButton] = [TenGridButton]()
    var gridUsers: [AnyObject] = [AnyObject]()
    
    private var spots: [CGPoint] = [CGPoint]()
    
    func clearNodes() {
        for node in nodes {
            node.removeFromSuperview()
        }
        spots.removeAll()
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
            
            var x = CGFloat(drand48()) * SCREEN_WIDTH*4/5 + SCREEN_WIDTH/10
            var y = CGFloat(drand48()) * SCREEN_HEIGHT*3/5 + SCREEN_HEIGHT/5
            
            var good = false
            while !good {
                
                good = true
                for spot in spots {
                
                    let xDiff = abs(x-spot.x)
                    let yDiff = abs(y-spot.y)

                    let xAway = x-SCREEN_WIDTH/2
                    let yAway = y-SCREEN_HEIGHT/2

                    let away = xAway*xAway+yAway*yAway

                    let inProfileIcon = (x<(SCREEN_WIDTH/2+profileIconRadius) && x>(SCREEN_WIDTH/2-profileIconRadius))||(y<(SCREEN_HEIGHT/2-profileIconRadius) && y>(SCREEN_HEIGHT/2+profileIconRadius))
                    if xDiff < minDiff || yDiff < minDiff || away > radiusSQ || inProfileIcon {
                        x = CGFloat(drand48()) * SCREEN_WIDTH*4/5 + SCREEN_WIDTH/10
                        y = CGFloat(drand48()) * SCREEN_HEIGHT*3/5 + SCREEN_HEIGHT/5
                        
                        good = false
                        break
                    }
                }
            }
            spots.append(CGPointMake(x, y))
            
            let node = TenGridButton(frame: CGRectMake(spots[i].x, spots[i].y, SCREEN_WIDTH/20, SCREEN_WIDTH/20))
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
}