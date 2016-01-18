//
//  PCoinTransView.swift
//  Ten
//
//  Created by gt on 16/1/17.
//  Copyright © 2016年 LiMao Tech. All rights reserved.
//

import UIKit

protocol PCoinTransDelegate:class{
    func PCoinTransViewCancelBtnClicked()
    func PCoinTransViewOkBtnClicked()
}

class PCoinTransView: UIView {
    var delegate:PCoinTransDelegate?
    var tenUser:TenUser!{
        didSet{
            headImageView.image = Tools.toCirclurImage(tenUser.PortraitImage!)
        }
    }
    var isShow = false
    let contentL = SCREEN_WIDTH-80
    let contentH:CGFloat = 140
    var contentView:UIView!
    var transLabel:UILabel!
    var pcoinImage:UIImageView!
    var headImageView:UIImageView!
    var pcoinTF:UITextField!
    var toLabel:UILabel!
    var okBtn:UIButton!
    var cancelBtn:UIButton!
    
    init(){
        super.init(frame: CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT))
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setup(){
        let blur = UIBlurEffect(style: .Dark)
        let blurView = UIVisualEffectView(effect: blur)
        blurView.alpha = 0.6
        blurView.frame = CGRectMake(0,0,SCREEN_WIDTH, SCREEN_HEIGHT)
        self.addSubview(blurView)
        let gap:CGFloat = 20
        contentView = UIView(frame: CGRectMake(0,0,contentL,contentH))
        contentView.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2)
        contentView.layer.cornerRadius = 7.0
        contentView.layer.masksToBounds = true
        contentView.backgroundColor = BG_COLOR
        self.addSubview(contentView)
        transLabel = UILabel(frame: CGRectMake(0,10,contentL,20))
        transLabel.textAlignment = .Center
        transLabel.text = "赠送P币"
        transLabel.textColor = UIColor.whiteColor()
        transLabel.font = UIFont.systemFontOfSize(17)
        contentView.addSubview(transLabel)
        var y = CGRectGetMaxY(transLabel.frame)+10
        pcoinImage = UIImageView(frame: CGRectMake(gap,y,50,50))
        pcoinImage.image = UIImage(named: "icon_pcoin_88")
        contentView.addSubview(pcoinImage)
        headImageView = UIImageView(frame: CGRectMake(contentL-60,y,50,50))
        contentView.addSubview(headImageView)
        y += 15
        toLabel = UILabel(frame: CGRectMake(contentL-100,y,40,20))
        toLabel.textAlignment = .Center
        toLabel.text = "to"
        toLabel.textColor = UIColor.whiteColor()
        toLabel.font = UIFont.systemFontOfSize(15)
        contentView.addSubview(toLabel)
        var w = contentL - 180
        y -= 5
        pcoinTF = UITextField(frame: CGRectMake(CGRectGetMaxX(pcoinImage.frame)+10,y,w,30))
        pcoinTF.layer.cornerRadius = 7.0
        pcoinTF.layer.masksToBounds = true
        pcoinTF.backgroundColor = UIColor.whiteColor()
        pcoinTF.leftViewMode = .Always
        pcoinTF.leftView = UIView(frame: CGRectMake(0,0,3,30))
        contentView.addSubview(pcoinTF)
        y = CGRectGetMaxY(pcoinImage.frame) + 10
        let splitLine = UIView(frame: CGRectMake(0,y,contentL,1))
        splitLine.backgroundColor = UIColor.whiteColor()
        splitLine.alpha = 0.4
        contentView.addSubview(splitLine)
        y = CGRectGetMaxY(splitLine.frame)
        w = (contentL-1)/2
        cancelBtn = UIButton(frame: CGRectMake(0,y,w,39))
        cancelBtn.setTitle("取消", forState: .Normal)
        cancelBtn.addTarget(self, action: "cancelClicked", forControlEvents: .TouchUpInside)
        contentView.addSubview(cancelBtn)
        let splitLineMid = UIView(frame: CGRectMake(w,y,1,39))
        splitLineMid.backgroundColor = UIColor.whiteColor()
        splitLineMid.alpha = 0.4
        contentView.addSubview(splitLineMid)
        okBtn = UIButton(frame: CGRectMake(w+1,y,w,39))
        okBtn.setTitle("确认", forState: .Normal)
        okBtn.addTarget(self, action: "okClicked", forControlEvents: .TouchUpInside)
        contentView.addSubview(okBtn)
    }
    
    func cancelClicked(){
        self.delegate?.PCoinTransViewCancelBtnClicked()
    }
    
    func okClicked(){
        self.delegate?.PCoinTransViewOkBtnClicked()
    }
    
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
    // Drawing code
    }
    */

}
