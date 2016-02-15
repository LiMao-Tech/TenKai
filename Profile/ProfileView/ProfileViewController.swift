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
    let albumBtn = UIBarButtonItem()

    var numProfilePics = 1
    
    var userID: Int!

    var imagesJSON: [AnyObject]?


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
        
        // add Image Button
        albumBtn.title = "相簿"
        albumBtn.style = .Plain
        albumBtn.target = self
        albumBtn.action = "pushPictureCollectionView"
        self.navigationItem.rightBarButtonItem = albumBtn
        
        // level
        self.separatorImageView.backgroundColor = UIColor.whiteColor()
    }
    
    override func viewWillAppear(animated: Bool) {
        // update profile picture
        self.navigationController?.navigationBar.translucent = false
        self.navigationController?.navigationBar.hidden = false

        if imagesJSON == nil {
            albumBtn.enabled = false
            getImagesJSON()
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.navigationController?.navigationBar.translucent = true
    }
    
    func pushPictureCollectionView() {
        // virtual
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func getImagesJSON() {

        if let json = TenImagesJSONManager.SharedInstance.imagesJSON {
            if userID == SHARED_USER.UserIndex {
                imagesJSON = json
            }
        }
        else {
            let targetUrl = Url_ImagesJSON + String(userID)

            ALAMO_MANAGER.request(.GET, targetUrl) .responseJSON {
                response in
                if let values = response.result.value {
                    self.albumBtn.enabled = true
                    self.imagesJSON = (values as? [AnyObject])!

                    for obj in self.imagesJSON! {
                        let imageJSON = JSON(obj)

                        if imageJSON["ImageType"].intValue == 0 {
                            self.image1JSON = imageJSON
                        }

                        if imageJSON["ImageType"].intValue == 3 {
                            self.numProfilePics = 2
                            self.image2JSON = imageJSON
                        }

                        if imageJSON["ImageType"].intValue == 4 {
                            self.numProfilePics = 3
                            self.image3JSON = imageJSON
                        }
                    }
                    
                    self.setScrollView()
                    self.getProfileImages()
                    
                }
            }
        }
    }
    
    private func getProfileImages() -> Void {
        if let json = image1JSON {


            if let image = SHARED_IMAGE_CACHE.imageWithIdentifier(json["FileName"].stringValue) {
                self.profileIV1?.image = image
            }
            else {
                let targetUrl = Url_Image + json["ID"].stringValue
                ALAMO_MANAGER.request(.GET, targetUrl).responseImage { response in
                    if let image = response.result.value {
                        self.profileIV1?.image = image
                        SHARED_IMAGE_CACHE.addImage(image, withIdentifier: json["FileName"].stringValue)
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

    private func setScrollView() {

        profileIV1 = UIImageView(frame: CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT*2/3))
        profileIV1!.contentMode = .ScaleAspectFill
        profileIV1!.clipsToBounds = true

        profileIV2 = UIImageView(frame: CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT*2/3))
        profileIV2!.contentMode = .ScaleAspectFill
        profileIV2!.clipsToBounds = true

        profileIV3 = UIImageView(frame: CGRectMake(SCREEN_WIDTH*2, 0, SCREEN_WIDTH, SCREEN_HEIGHT*2/3))
        profileIV3!.contentMode = .ScaleAspectFill
        profileIV3!.clipsToBounds = true

        profileSV.contentSize = CGSizeMake(SCREEN_WIDTH*CGFloat(numProfilePics), profileSV.frame.height)

        profileSV.addSubview(profileIV1!)

        if numProfilePics > 1 {
            profileSV.addSubview(profileIV2!)
        }
        if numProfilePics > 2 {
            profileSV.addSubview(profileIV3!)
        }

    }
}