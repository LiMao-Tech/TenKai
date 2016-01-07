//
//  GTSlider.swift
//  Ten
//
//  Created by gt on 15/11/14.
//  Copyright © 2015年 LiMao Tech. All rights reserved.
//

import UIKit

class GTSlider: UISlider {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setThumbImage(UIImage(named: "circle_outer_profile"), forState: .Normal)
        self.setMinimumTrackImage(UIImage(named: "line_profile_highlight"), forState: .Normal)
        self.setMaximumTrackImage(UIImage(named: "line_profile_normal"), forState: .Normal)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
