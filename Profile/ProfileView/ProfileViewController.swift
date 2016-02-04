//
//  ProfileViewController.swift
//  Ten
//
//  Created by Yumen Cao on 10/1/15.
//  Copyright © 2015 LiMao Tech. All rights reserved.
//

import UIKit
import AlamofireImage
import SwiftyJSON

class ProfileViewController: UIViewController,
                                UIScrollViewDelegate
{
    
    @IBOutlet weak var profileSV: UIScrollView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    
    @IBOutlet weak var levelBarImageView: UIImageView!
    @IBOutlet weak var levelCircleImageView: UIImageView!
    @IBOutlet weak var separatorImageView: UIImageView!
    @IBOutlet weak var pcoindistanceImageView: UIImageView!
    @IBOutlet weak var pcoindistanceLabel: UILabel!
    
    @IBOutlet weak var locationImageView: UIImageView!
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var quoteLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    
    let gradientMask = CAGradientLayer()
    
    var userID: Int!
    
    var profileIV1: UIImageView?
    var profileIV2: UIImageView?
    var profileIV3: UIImageView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //  set scroll view
        profileIV1 = UIImageView(frame: CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT*2/3))
        
        profileIV1!.contentMode = .ScaleAspectFill
        profileIV1!.clipsToBounds = true
        
        profileIV2 = UIImageView(frame: CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT*2/3))
        profileIV2!.contentMode = .ScaleAspectFill
        profileIV2!.clipsToBounds = true
        
        profileIV3 = UIImageView(frame: CGRectMake(SCREEN_WIDTH*2, 0, SCREEN_WIDTH, SCREEN_HEIGHT*2/3))
        profileIV3!.contentMode = .ScaleAspectFill
        profileIV3!.clipsToBounds = true
        
        profileSV.contentSize = CGSizeMake(SCREEN_WIDTH*3, profileSV.frame.height)
        profileSV.addSubview(profileIV1!)
        profileSV.addSubview(profileIV2!)
        profileSV.addSubview(profileIV3!)
        
        profileSV.delegate = self

        getProfileImage()
        
        self.title = ProfileTitle
        self.view.backgroundColor = COLOR_BG
        
        // add Image Button
        let addImageBtn = UIBarButtonItem(title: "相簿", style: .Plain, target: self, action: "pushPictureCollectionView")
        self.navigationItem.rightBarButtonItem = addImageBtn
        
        // level
        self.separatorImageView.backgroundColor = UIColor.whiteColor()
        
        var avg = Int(ceil((Double(SHARED_USER.OuterScore) + Double(SHARED_USER.InnerScore))/2))
        if avg == 0 {
            avg = 1
        }
        self.levelCircleImageView.image = UIImage(named: "icon_profile_circle_l\(avg)")
        self.levelBarImageView.backgroundColor = UIColor.redColor()
            //LEVEL_COLORS[9]
        
        print("level: \(avg-1)")
    }
    
    override func viewWillAppear(animated: Bool) {
        // update profile picture
        self.navigationController!.navigationBar.translucent = false
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.navigationController!.navigationBar.translucent = true
    }
    
    func pushPictureCollectionView() {
        // virtual
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func getProfileImage() -> Void {
        let imageIndex = String(userID)
        let targetUrl = HeadImageGetUrl + imageIndex
        ALAMO_MANAGER.request(.GET, targetUrl)
            .responseImage { response in
                if let image = response.result.value {
                    self.profileIV1?.image = image
                    self.profileIV2?.image = image
                    self.profileIV3?.image = image
                }
        }
    }
}