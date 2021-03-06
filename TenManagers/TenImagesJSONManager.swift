//
//  TenImagesJSONManager.swift
//  Ten
//
//  Created by Yumen Cao on 2/4/16.
//  Copyright © 2016 LiMao Tech. All rights reserved.
//

import SwiftyJSON
import Alamofire
import AlamofireImage


class TenImagesJSONManager: NSObject {
    
    static let SharedInstance = TenImagesJSONManager()

    var managedController: MyProfilePicsViewController?
    var imagesJSON: [AnyObject]?
    
    
    override init() {
        
        
    }

    func getJSONUpdating(master: MeProfileMasterViewController, alert: UIAlertController) -> Void {

        let targetUrl = Url_ImagesJSON + String(SHARED_USER.UserIndex)
        
        ALAMO_MANAGER.request(.GET, targetUrl) .responseJSON { response in

            if let values = response.result.value {
                self.imagesJSON = (values as? [AnyObject])!
                master.pPCVC.imagesJSON = self.imagesJSON!
                master.pPCVC.dataInit()
                master.pPCVC.lmCollectionView.reloadData()
                
                alert.dismissViewControllerAnimated(true, completion: nil)
            }
        }

    }
}
