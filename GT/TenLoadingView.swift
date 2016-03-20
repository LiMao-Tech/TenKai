//
//  TenLoadingView.swift
//  Ten
//
//  Created by gt on 16/3/20.
//  Copyright © 2016年 LiMao Tech. All rights reserved.
//

import UIKit

class TenLoadingView: UIView {
    private let contentL = SCREEN_WIDTH-110
    private let contentH:CGFloat = 120
    private var title:UILabel!
    var loadingTitle = ""{
        didSet{
            title.text = loadingTitle
        }
    }
    var acIndicator:UIActivityIndicatorView!
    init(){
        super.init(frame: CGRectMake(0,0,contentL,contentH))
        self.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2)
        acIndicator = UIActivityIndicatorView(frame: CGRectMake(0,0,80,80))
        acIndicator.center = CGPointMake(contentL/2, 40)
        acIndicator.activityIndicatorViewStyle = .WhiteLarge
        self.addSubview(acIndicator)
        title = UILabel(frame: CGRectMake(0,0,SCREEN_WIDTH,40))
        title.center = CGPointMake(contentL/2, 100)
        title.textAlignment = .Center
        title.textColor = UIColor.whiteColor()
        title.font = UIFont.systemFontOfSize(18)
        self.addSubview(title)
        self.backgroundColor = UIColor.blackColor()
        self.layer.cornerRadius = 7
        self.layer.masksToBounds = true
        acIndicator.startAnimating()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
