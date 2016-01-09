//
//  ProfileViewController.swift
//  Ten
//
//  Created by Yumen Cao on 10/1/15.
//  Copyright © 2015 LiMao Tech. All rights reserved.
//

import UIKit

private let InitialBlockPixelSize : Int = 75

class ProfileViewController: UIViewController {
    
    var userID: Int!
    
    var userNameLabel = UILabel(frame: CGRectMake(20, SCREEN_HEIGHT-150, SCREEN_WIDTH-40, 35))
    let scoreLabel = UILabel(frame: CGRectMake(0, SCREEN_HEIGHT-40, SCREEN_WIDTH-70, 50))
    let quoteLabel = UILabel(frame: CGRectMake(20, SCREEN_HEIGHT-80, SCREEN_WIDTH-60, 70))
    let locationLabel = UILabel(frame: CGRectMake(SCREEN_WIDTH/2, SCREEN_HEIGHT-90, SCREEN_WIDTH/2, 15))
    
    var profileImageView = UIImageView(frame: CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.title = ProfileTitle
        
        // profile picture
        self.view.backgroundColor = UIColor.blackColor()
        self.profileImageView.contentMode = UIViewContentMode.ScaleAspectFill
        
        // gradient mask
        let gradientMask = CAGradientLayer()
        gradientMask.frame = self.view.bounds
        gradientMask.colors = [UIColor.blackColor().CGColor, UIColor.clearColor().CGColor]
        self.profileImageView.layer.mask = gradientMask;
        
        // button to show more pictures
        let morePictureButton = UIButton(type: UIButtonType.RoundedRect)
        morePictureButton.frame = CGRectMake(SCREEN_WIDTH-40, SCREEN_HEIGHT-40, 30, 30)
        morePictureButton.setBackgroundImage(UIImage(named: "btn_profile_down"), forState: UIControlState.Normal)
        morePictureButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        morePictureButton.addTarget(self, action: "pushPictureCollectionView", forControlEvents: UIControlEvents.TouchUpInside)
        morePictureButton.tintColor = UIColor.whiteColor()
        
        
        scoreLabel.textColor = UIColor.whiteColor()
        scoreLabel.textAlignment = NSTextAlignment.Center
        scoreLabel.font = UIFont.systemFontOfSize(PROFILE_FONT_SIZE)
        
        // quoteLabel
        quoteLabel.textColor = UIColor.whiteColor()
        quoteLabel.textAlignment = NSTextAlignment.Left
        quoteLabel.font = UIFont.systemFontOfSize(PROFILE_FONT_SIZE)
        quoteLabel.numberOfLines = 3
        
        // add location icon
        let locationIcon = UIImageView(frame: CGRectMake(SCREEN_WIDTH/2-30, SCREEN_HEIGHT-90, 25, 15))
        locationIcon.contentMode = UIViewContentMode.ScaleAspectFit
        locationIcon.image = UIImage(named: "icon_profile_location")
        
        // add location text
        locationLabel.textColor = UIColor.whiteColor()
        locationLabel.textAlignment = NSTextAlignment.Left
        locationLabel.font = UIFont.systemFontOfSize(PROFILE_FONT_SIZE)
        
        // add pcoin icon
        let pcoinIcon = UIImageView(frame: CGRectMake(SCREEN_WIDTH/2-30, SCREEN_HEIGHT-110, 25, 15))
        pcoinIcon.contentMode = UIViewContentMode.ScaleAspectFit
        pcoinIcon.image = UIImage(named: "icon_pcoin_35")
        
        // add pcoin amount text
        let pcoinLabel = UILabel(frame: CGRectMake(SCREEN_WIDTH/2, SCREEN_HEIGHT-110, SCREEN_WIDTH/2, 15))
        pcoinLabel.textColor = UIColor.whiteColor()
        pcoinLabel.text = "2,500"
        pcoinLabel.textAlignment = NSTextAlignment.Left
        pcoinLabel.font = UIFont.systemFontOfSize(PROFILE_FONT_SIZE)
        
        // add user name and age
        userNameLabel.textColor = UIColor.whiteColor()
        userNameLabel.textAlignment = NSTextAlignment.Center
        userNameLabel.font = UIFont.systemFontOfSize(USERNAME_FONT_SIZE)
        
        // add all
        self.view.addSubview(morePictureButton)
        self.view.addSubview(scoreLabel)
        self.view.addSubview(quoteLabel)
        self.view.addSubview(locationIcon)
        self.view.addSubview(locationLabel)
        self.view.addSubview(pcoinIcon)
        self.view.addSubview(pcoinLabel)
        self.view.addSubview(userNameLabel)
    }
    
    override func viewWillAppear(animated: Bool) {
        // update profile picture everytime
        
        
        
    }
    
    func pushPictureCollectionView() {
        // virtual
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}