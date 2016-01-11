//
//  OtherProfileViewController.swift
//  Ten
//
//  Created by Yumen Cao on 1/4/16.
//  Copyright © 2016 LiMao Tech. All rights reserved.
//

import UIKit

class OtherProfileViewController: ProfileViewController {
    
    var outerBar: GTSlider!
    var outerValue: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        outerBar = GTSlider(frame: CGRectMake(SCREEN_WIDTH/5, SCREEN_HEIGHT*11/12, SCREEN_WIDTH/2, SCREEN_HEIGHT/12))
        
        outerBar.minimumValue = MinBarValue
        outerBar.maximumValue = MaxBarValue
        
        outerBar.addTarget(self, action: "outerBarChanged", forControlEvents: UIControlEvents.ValueChanged)
        
        outerValue = UILabel(frame: CGRectMake(SCREEN_WIDTH*4/5, SCREEN_HEIGHT*11/12, SCREEN_WIDTH/2, SCREEN_HEIGHT/12))
        outerValue.text = "0"
        outerValue.textColor = UIColor.whiteColor()

        self.view.addSubview(outerBar)
        self.view.addSubview(outerValue)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func pushPictureCollectionView() {
        let pPCVC = MyProfilePicsCollectionViewController(height: SCREEN_HEIGHT, width: SCREEN_WIDTH, toolbarHeight: 0, userId: self.userID)
        
        self.navigationController?.pushViewController(pPCVC, animated: true)
    }

    
    func outerBarChanged(){
        outerValue.text = "\(Int(outerBar.value))"
    }
    
    
    
}
