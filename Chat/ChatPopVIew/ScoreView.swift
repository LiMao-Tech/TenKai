//
//  ScoreView.swift
//  Ten
//
//  Created by gt on 16/1/17.
//  Copyright © 2016年 LiMao Tech. All rights reserved.
//

import UIKit
protocol ScoreViewDelegate:class{
    func scoreViewScoreChange()
    func scoreViewCancelBtnClicked()
    func scoreViewOkBtnClicked()
}

class ScoreView: UIView {
    var delegate:ScoreViewDelegate?
    var tenUser:TenUser!{
        didSet{
            nameLabel.text = tenUser.UserName
            headImageView.image = Tools.toCirclurImage(tenUser.PortraitImage!)
        }
    }
    let contentL = SCREEN_WIDTH-80
    let contentH:CGFloat = 140
    var contentView:UIView!
    var nameLabel:UILabel!
    var headImageView:UIImageView!
    var scoreSlider:GTSlider!
    var scoreLabel:UILabel!
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
        contentView.backgroundColor = COLOR_BG
        self.addSubview(contentView)
        nameLabel = UILabel(frame: CGRectMake(0,10,contentL,20))
        nameLabel.textAlignment = .Center
        nameLabel.text = "UserName"
        nameLabel.textColor = UIColor.whiteColor()
        nameLabel.font = UIFont.systemFontOfSize(17)
        contentView.addSubview(nameLabel)
        var y = CGRectGetMaxY(nameLabel.frame)+10
        headImageView = UIImageView(frame: CGRectMake(gap,y,50,50))
        headImageView.image = UIImage(named: "user_pic_radar_55")
        contentView.addSubview(headImageView)
        y += 15
        scoreLabel = UILabel(frame: CGRectMake(contentL-gap*2,y,20,20))
        scoreLabel.textAlignment = .Right
        scoreLabel.text = "0"
        scoreLabel.textColor = UIColor.whiteColor()
        scoreLabel.font = UIFont.systemFontOfSize(15)
        contentView.addSubview(scoreLabel)
        var w = contentL-gap*2-headImageView.frame.width-scoreLabel.frame.width-gap
        scoreSlider = GTSlider(frame: CGRectMake(CGRectGetMaxX(headImageView.frame)+10,y,w,20))
        scoreSlider.addTarget(self, action: "scoreChange", forControlEvents: .ValueChanged)
        scoreSlider.maximumValue = 10
        scoreSlider.minimumValue = 0
        contentView.addSubview(scoreSlider)
        y = CGRectGetMaxY(headImageView.frame) + 10
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
    
    func scoreChange(){
        self.delegate?.scoreViewScoreChange()
    }
    
    func cancelClicked(){
        self.delegate?.scoreViewCancelBtnClicked()
    }
    
    func okClicked(){
        self.delegate?.scoreViewOkBtnClicked()
    }
    
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
