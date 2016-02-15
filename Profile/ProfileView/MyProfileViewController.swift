//
//  MyProfileViewController.swift
//  Ten
//
//  Created by Yumen Cao on 1/4/16.
//  Copyright © 2016 LiMao Tech. All rights reserved.
//

import UIKit
import CoreLocation

class MyProfileViewController: ProfileViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLabel.text = SHARED_USER.UserName
        ageLabel.text = String(TenTimeManager.SharedInstance.getAge(NSDate(timeIntervalSince1970:SHARED_USER.Birthday)))
        pcoindistanceLabel.text = String(SHARED_USER.PCoin)
        
        self.scoreLabel.text = "内在: \(SHARED_USER.InnerScore)   外在: \(SHARED_USER.OuterScore)   能量： \(SHARED_USER.Energy)"
        quoteLabel.text = SHARED_USER.Quote
        
        if let loc = LOC_MANAGER.location {
            GEO_DECODER.reverseGeocodeLocation(loc) {
                (placemarks, error) -> Void in
                if (placemarks != nil) {
                    let locText = String(placemarks![0].addressDictionary!["Country"]!)+" "+String(placemarks![0].addressDictionary!["City"]!)
                    self.locationLabel.text = locText
                }
                else {
                    self.locationLabel.text = "未知"
                }
            }
        }
        else {
            self.locationLabel.text = "未知"
        }

        var avg = Int(ceil((Double(SHARED_USER.OuterScore) + Double(SHARED_USER.InnerScore))/2))
        if avg == 0 {
            avg = 1
        }
        self.levelCircleImageView.image = UIImage(named: "icon_profile_circle_l\(avg)")
        self.levelBarImageView.backgroundColor = LEVEL_COLORS[avg-1]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }

    
    
    override func pushPictureCollectionView() {
        let pPCVC = MyProfilePicsViewController(nibName: "MyProfilePicsViewController", bundle: nil)
        pPCVC.imagesJSON = imagesJSON
        pPCVC.image1JSON = image1JSON
        pPCVC.image2JSON = image2JSON
        pPCVC.image3JSON = image3JSON

        TenImagesJSONManager.SharedInstance.imagesJSON = imagesJSON
        self.navigationController?.pushViewController(pPCVC, animated: true)
    }
}
