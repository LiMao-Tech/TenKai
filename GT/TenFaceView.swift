//
//  GTFaceView.swift
//  swiftChat
//
//  Created by gt on 15/9/14.
//  Copyright (c) 2015年 gt. All rights reserved.
//

import UIKit
protocol TenFaceViewDelegate : class{
    func faceButtonDidClicked(faceBtn :TenFaceButton)
    func backButtonDidClicked()
}

var faceCodes = NSMutableArray()
class TenFaceView: UIView {
    var faceMap = NSDictionary()
    var faceView : UIScrollView
    var delegate : TenFaceViewDelegate?
    
    let screen = UIScreen.mainScreen().bounds.size
    init() {
        faceMap = NSDictionary(contentsOfFile: NSBundle.mainBundle().pathForResource("_expression_en", ofType: "plist")!)!
        faceView = UIScrollView(frame: CGRectMake(0, 0, screen.width, 200))
        faceView.pagingEnabled = true
        faceView.showsHorizontalScrollIndicator = false
        faceView.showsVerticalScrollIndicator = false
        faceView.bounces = false
        super.init(frame: CGRectMake(0, 0, screen.width, 240))
        
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
            let x = margin+c*(margin+w)+screen.width*CGFloat(p)
            let y = (r%CGFloat(row))*(h+margin)
            faceBtn.frame = CGRectMake(x, y, w, h)
            let imageName = NSString(format: "%03d", i)
            faceBtn.faceCode = NSString(format:"[%03d]", i)
            faceBtn.faceImage = UIImage(named: imageName as String)
            faceBtn.addTarget(self, action: #selector(TenFaceView.faceBtnClicked(_:)), forControlEvents: .TouchUpInside)
            faceView.addSubview(faceBtn)
            faceCodes.addObject(faceBtn.faceCode)
        }
        
        //pagecontrol
        self.backgroundColor = UIColor(red: 236.0/255.0, green: 236.0/255.0, blue: 236.0/255.0, alpha: 1.0)
        let backBtn = UIButton(frame: CGRectMake(screen.width-48,4*(h+margin),38,28))
        backBtn.setImage(UIImage(named: "del_emoji_select"), forState: .Normal)
        backBtn.addTarget(self, action: #selector(TenFaceView.backBtnClicked), forControlEvents: .TouchUpInside)
        self.addSubview(backBtn)
        self.addSubview(faceView)
        
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func backBtnClicked(){
        if(delegate != nil){
            self.delegate?.backButtonDidClicked()
        }
    }
    func faceBtnClicked(btn:TenFaceButton){
        if(delegate != nil){
            self.delegate?.faceButtonDidClicked(btn)
        }
    }
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
