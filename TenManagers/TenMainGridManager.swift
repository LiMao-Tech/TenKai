//
//  MainGrid.swift
//  Ten
//
//  Created by Yumen Cao on 2/1/16.
//  Copyright © 2016 LiMao Tech. All rights reserved.
//

import UIKit


// boolean table

class TenMainGridManager: NSObject {
    
    private let minDistSq = 15^2
    
    static let SharedInstance = MainGridManager()
    
    var nodes: [UIButton] = [UIButton]()
    var spots: [CGPoint] = [CGPoint]()
    
    func selectPoints() -> [CGPoint] {
        
        var rs = [CGPoint]()
        
        for _ in 1...10 {
            
            var x = drand48()
            var y = drand48()
            
            for spot in spots {
                var diff = (x-spot.x)^2 + (y-spot.y)^2
                
                while diff < minDistSq {
                    x = drand48()
                    y = drand48()
                    
                    diff = (x-spot.x)^2 + (y-spot.y)^2
                }
            }
            rs.append(stars[i][j])
        }
        
        return rs
    }

}