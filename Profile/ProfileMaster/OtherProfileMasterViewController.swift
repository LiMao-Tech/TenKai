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


    var tenUser: TenUser!

    override func viewDidLoad() {
        super.viewDidLoad()
        let chatBtn = UIBarButtonItem(image: UIImage(named: "btn_navBarIcon_chat_normal"), style: .Plain, target: self, action: "pushChatView")
        self.navigationItem.rightBarButtonItem = chatBtn;

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    private func getImagesJSON() {
        let targetUrl = Url_ImagesJSON + String(userID)

        ALAMO_MANAGER.request(.GET, targetUrl) .responseJSON {
            response in
            print(response.debugDescription)
            if let values = response.result.value {

                self.imagesJSON = (values as? [AnyObject])!

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


        self.presentViewController(singleChatC, animated: true, completion: nil)
    }

}
