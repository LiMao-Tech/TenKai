//
//  GTFaceView.swift
//  swiftChat
//
//  Created by gt on 15/9/14.
//  Copyright (c) 2015年 gt. All rights reserved.
//

import UIKit

var faceCodes = NSMutableArray()
class TenFaceView: UIView {
    var faceMap = NSDictionary()
    var faceView : UIScrollView
    
    let screen = UIScreen.mainScreen().bounds.size
    init(faceDelegateTemp:TenFaceButtonDelegate) {
        faceMap = NSDictionary(contentsOfFile: NSBundle.mainBundle().pathForResource("_expression_en", ofType: "plist")!)!
        faceView = UIScrollView(frame: CGRectMake(0, 0, screen.width, 200))
        faceView.pagingEnabled = true
        faceView.showsHorizontalScrollIndicator = false
        faceView.showsVerticalScrollIndicator = false
        faceView.bounces = false
        
        let column: Int = 7
        let row: Int = 4
        let page = (faceMap.count)/(column*row)
        faceView.contentSize = CGSizeMake((screen.width*CGFloat(page)), 0.0)
        let w:CGFloat = 40
        let h:CGFloat = 40
        let wAll = CGFloat(column)*w
        let margin = (screen.width - wAll)/(CGFloat(column + 1))
        for i in 1...faceMap.count{
            let faceBtn:TenFaceButton = TenFaceButton(frame: CGRectMake(0, 0, 0, 0))
            let c = CGFloat((i-1)%column)
            let r = CGFloat((i-1)/column)
            let p = (i-1)/(column*row)
//            println("\(c)+\(r)+\(p)")
            let x = margin+c*(margin+w)+screen.width*CGFloat(p)
            let y = (r%CGFloat(row))*(h+margin)
            faceBtn.frame = CGRectMake(x, y, w, h)
            let imageName = NSString(format: "%03d", i)
            faceBtn.faceCode = NSString(format:"[%03d]", i)
            faceBtn.faceImage = UIImage(named: imageName as String)
            faceBtn.delegate = faceDelegateTemp
            faceView.addSubview(faceBtn)
            faceCodes.addObject(faceBtn.faceCode)
        }
        
        //pagecontrol
        super.init(frame: CGRectMake(0, 0, screen.width, 224))
        self.backgroundColor = UIColor(red: 236.0/255.0, green: 236.0/255.0, blue: 236.0/255.0, alpha: 1.0)
        self.addSubview(faceView)
        
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
