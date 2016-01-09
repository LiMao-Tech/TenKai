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
        
        
        self.userNameLabel.text = SHARED_USER.UserName
        self.scoreLabel.text = "内在 \(SHARED_USER.InnerScore)   外在 \(SHARED_USER.OuterScore)   能量 \(SHARED_USER.Energy)"
        
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
        
        
        quoteLabel.text = "1994年首次出演电视剧《红樱桃》，1997年凭借与张国荣合作的电影《红色恋人》获1998年第22届国际开罗电影节最佳女演员奖及1999年第5届中国电影华表奖最佳女演员奖[2]。2001年主演反映家庭暴力的电视剧《不要和陌生人说话》[3]  。2003年凭借电视剧《让爱重来》获得第21届中国电视金鹰奖观众喜爱的女演员奖[4]  。2005年凭借电影《阿司匹林》提名第25届中国电影金鸡奖最佳女主角[5]  。2015年10月凭借《推拿》获得第十五届华语电影传媒大奖最佳女配角奖[6]  。 2015年12月凭借《父母爱情》夺得飞天奖优秀女演员奖"
        
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
