//
//  MyProfileViewController.swift
//  Ten
//
//  Created by Yumen Cao on 1/4/16.
//  Copyright © 2016 LiMao Tech. All rights reserved.
//

import UIKit

class MyProfileViewController: ProfileViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
