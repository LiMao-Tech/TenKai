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

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var profileImageView: UIImageView!
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
    
    var userID: Int!
    
    let gradientMask = CAGradientLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getProfileImage()
        
        
        self.title = ProfileTitle
        self.view.backgroundColor = COLOR_BG
        
        // add Image Button
        let addImageBtn = UIBarButtonItem(title: "相簿", style: .Plain, target: self, action: "pushPictureCollectionView")
        self.navigationItem.rightBarButtonItem = addImageBtn
        
        // get level images
        self.separatorImageView.backgroundColor = UIColor.whiteColor()
        
        // gradient mask
        gradientMask.colors = [COLOR_BG.CGColor, UIColor.clearColor().CGColor]
//        gradientMask.frame =
//        maskImageView.layer.mask = gradientMask;
        
        // level colors
        let avg = round((Double(SHARED_USER.OuterScore) + Double(SHARED_USER.InnerScore))/2)
        self.levelCircleImageView.image = UIImage(named: "icon_profile_circle_l\(avg)")
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
                    self.profileImageView.image = image
                }
        }
    }
}