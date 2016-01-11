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
        
        
        nameAgeLabel.text = SHARED_USER.UserName
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
        
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    
    
    override func pushPictureCollectionView() {
        let pPCVC = MyProfilePicsCollectionViewController(height: SCREEN_HEIGHT, width: SCREEN_WIDTH, toolbarHeight: TOOL_BAR_HEIGHT, userId: self.userID)
        
        self.navigationController?.pushViewController(pPCVC, animated: true)
    }
}
