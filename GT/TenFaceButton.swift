//
//  GTFaceButton.swift
//  swiftChat
//
//  Created by gt on 15/9/14.
//  Copyright (c) 2015年 gt. All rights reserved.
//

import UIKit
//protocol TenFaceButtonDelegate : class{
//    func faceButtonDidClicked(faceBtn :TenFaceButton)
//}

class TenFaceButton: UIButton {
    var faceCode : NSString = ""
    var faceImage : UIImage?{
        willSet{
            self.setImage(newValue, forState: UIControlState.Normal)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.adjustsImageWhenHighlighted = false
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
//        let touch: UITouch = (touches as NSSet).anyObject() as! UITouch
//        let point: CGPoint = touch.locationInView(self)
//        if(CGRectContainsPoint(self.bounds, point)){
//            if((self.delegate) != nil){
//                self.delegate!.faceButtonDidClicked(self)
//            }
//        }
//    }
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
}
 