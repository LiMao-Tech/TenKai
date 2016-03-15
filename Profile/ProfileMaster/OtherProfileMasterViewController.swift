//
//  OtherProfileMasterViewController.swift
//  Ten
//
//  Created by Yumen Cao on 2/27/16.
//  Copyright © 2016 LiMao Tech. All rights reserved.
//

import UIKit
import SwiftyJSON

class OtherProfileMasterViewController: ProfileMasterViewController {



    let pVC = OtherProfileViewController(nibName: "ProfileViewController", bundle: nil)
    let pPCVC = OtherProfilePicsViewController(nibName: "OtherProfilePicsViewController", bundle: nil)


    let rateAlert = UIAlertView(title: "评分", message: "看过用户的首页。你帮他／她的外表评几分呢？", delegate: nil, cancelButtonTitle: "取消")
    
    var tenUser: TenUser!

    override func viewDidLoad() {
        super.viewDidLoad()
        let chatBtn = UIBarButtonItem(image: UIImage(named: "btn_navBarIcon_chat_normal"), style: .Plain, target: self, action: "pushChatView")
        
        self.navigationItem.rightBarButtonItem = chatBtn;

        let activeFrameHeight = SCREEN_HEIGHT-STATUSBAR_HEIGHT-(self.navigationController?.navigationBar.frame.height)!
        
        // child controller
        pVC.tenUser = tenUser
        pPCVC.tenUser = tenUser

        pVC.view.frame = CGRectMake(0, 0, profileSV.frame.width, profileSV.frame.height)
        pPCVC.view.frame = CGRectMake(0, activeFrameHeight, profileSV.frame.width, profileSV.frame.height)
        
        pPCVC.pVC = pVC

        addChildViewController(pVC)
        addChildViewController(pPCVC)

        profileSV.addSubview(pVC.view)
        profileSV.addSubview(pPCVC.view)


        getImagesJSON()


        // rating
        // TODO: Ask Tuantuan how to add slider rating
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    private func getImagesJSON() {
        let targetUrl = Url_ImagesJSON + String(userID)

        ALAMO_MANAGER.request(.GET, targetUrl) .responseJSON {
            response in
            
            if let values = response.result.value {

                let imagesJSON = (values as? [AnyObject])!
                self.imagesJSON = imagesJSON
                self.pPCVC.imagesJSON = imagesJSON
                self.pPCVC.lmCollectionView.reloadData()

                for obj in self.imagesJSON! {
                    let imageJSON = JSON(obj)

                    if imageJSON["ImageType"].intValue == 0 {
                        self.pVC.image1JSON = imageJSON
                    }

                    if imageJSON["ImageType"].intValue == 3 {
                        self.pVC.numProfilePics = 2
                        self.pVC.image2JSON = imageJSON
                    }

                    if imageJSON["ImageType"].intValue == 4 {
                        self.pVC.numProfilePics = 3
                        self.pVC.image3JSON = imageJSON
                    }
                }

                self.pVC.setScrollView()
                self.pVC.getProfileImages()
                self.pPCVC.dataInit()

            }
        }
    }

    // TODO: tuantuan
    func pushChatView() -> Void {
        let singleChatC = SingleChatController()
        singleChatC.tenUser = tenUser
        self.navigationController?.pushViewController(singleChatC, animated: true)
    }

}
