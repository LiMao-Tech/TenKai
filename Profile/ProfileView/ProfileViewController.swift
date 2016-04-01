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
    
    @IBOutlet weak var maskIV: UIImageView!
    
    let gradient = CAGradientLayer()
    let albumBtn = UIBarButtonItem()

    var numProfilePics = 1
    
    var userID: Int!
    
    var tenUser:TenUser!

    var image1JSON: JSON?
    var image2JSON: JSON?
    var image3JSON: JSON?

    var profileIV1: UIImageView?
    var profileIV2: UIImageView?
    var profileIV3: UIImageView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileSV.delegate = self

        
        self.title = ProfileTitle
        self.view.backgroundColor = COLOR_BG

        // setup gradient mask
        gradient.frame = CGRectMake(0, 0, SCREEN_WIDTH, maskIV.frame.height)
        gradient.colors = [UIColor.clearColor().CGColor, UIColor.blackColor().CGColor]
        maskIV.layer.addSublayer(gradient)
        //        maskIV.backgroundColor = COLOR_BG
//        maskIV.alpha = 0.2
        
        // add Image Button
        albumBtn.title = "相簿"
        albumBtn.style = .Plain
        albumBtn.target = self
        albumBtn.action = #selector(ProfileViewController.pushPictureCollectionView)
        self.navigationItem.rightBarButtonItem = albumBtn
        
        // level
        self.separatorImageView.backgroundColor = UIColor.whiteColor()
    }
    
    override func viewWillAppear(animated: Bool) {
        // update profile picture
    }
    
    override func viewWillDisappear(animated: Bool) {

    }
    
    func pushPictureCollectionView() {
        // virtual
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    func getProfileImages() -> Void {
        if let json = image1JSON {
            print("imagejson")
            if let image = SHARED_IMAGE_CACHE.imageWithIdentifier(json["FileName"].stringValue) {
                self.profileIV1?.image = image
                print("getfile")
                if(self.userID != nil && self.userID != SHARED_USER.UserIndex){
                    self.tenUser.Portrait = UIImagePNGRepresentation(image)
                    UsersCacheTool().upDateUsersPortrait(self.tenUser.UserIndex, portrait: image)
                }
            }
            else {
                let targetUrl = Url_Image + json["ID"].stringValue
                ALAMO_MANAGER.request(.GET, targetUrl).responseImage { response in
                    if let image = response.result.value {
                        print("getnet")
                        self.profileIV1?.image = image
                        SHARED_IMAGE_CACHE.addImage(image, withIdentifier: json["FileName"].stringValue)
                        if(self.userID != nil && self.userID != SHARED_USER.UserIndex){
                            self.tenUser.Portrait = UIImagePNGRepresentation(image)
                            UsersCacheTool().upDateUsersPortrait(self.tenUser.UserIndex, portrait: image)
                        }
                    }
                }
            }
        }

        if let json = image2JSON {
            if let image = SHARED_IMAGE_CACHE.imageWithIdentifier(json["FileName"].stringValue) {
                self.profileIV2?.image = image
            }
            else {
                let targetUrl = Url_Image + json["ID"].stringValue
                ALAMO_MANAGER.request(.GET, targetUrl).responseImage { response in
                    if let image = response.result.value {
                        self.profileIV2?.image = image
                        SHARED_IMAGE_CACHE.addImage(image, withIdentifier: json["FileName"].stringValue)
                    }
                }
            }
        }

        if let json = image3JSON {
            if let image = SHARED_IMAGE_CACHE.imageWithIdentifier(json["FileName"].stringValue) {
                self.profileIV3?.image = image
            }
            else {
                let targetUrl = Url_Image + json["ID"].stringValue
                ALAMO_MANAGER.request(.GET, targetUrl).responseImage { response in
                    if let image = response.result.value {
                        self.profileIV3?.image = image
                        SHARED_IMAGE_CACHE.addImage(image, withIdentifier: json["FileName"].stringValue)
                    }
                }
            }
        }
    }

    func setScrollView() {
        profileSV.contentSize = CGSizeMake(SCREEN_WIDTH*CGFloat(numProfilePics), profileSV.frame.height)

        profileIV1 = UIImageView(frame: CGRectMake(0, 0, SCREEN_WIDTH, profileSV.frame.height))
        profileIV1!.contentMode = .ScaleAspectFill
        profileIV1!.clipsToBounds = true
        profileSV.addSubview(profileIV1!)

        if numProfilePics > 1 {
            profileIV2 = UIImageView(frame: CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, profileSV.frame.height))
            profileIV2!.contentMode = .ScaleAspectFill
            profileIV2!.clipsToBounds = true
            profileSV.addSubview(profileIV2!)
        }
        if numProfilePics > 2 {
            profileIV3 = UIImageView(frame: CGRectMake(SCREEN_WIDTH*2, 0, SCREEN_WIDTH, profileSV.frame.height))
            profileIV3!.contentMode = .ScaleAspectFill
            profileIV3!.clipsToBounds = true
            profileSV.addSubview(profileIV3!)
        }
    }
}
