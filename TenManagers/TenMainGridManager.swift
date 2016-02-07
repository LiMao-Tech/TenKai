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
    
    private let minDiff: CGFloat = 15
    
    static let SharedInstance = TenMainGridManager()
    
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
    
    func createButtons() -> [TenGridButton] {
        gridUsers = TenOtherUsersJSONManager.SharedInstance.selectGridUsers()
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
                    
                    if xDiff < minDiff || yDiff < minDiff {
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
            node.tenUserJSON = JSON(gridUsers[i] as! [String : AnyObject])
            
            let userJSONDict = node.tenUserJSON
            if userJSONDict["Gender"].intValue == 0 {
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