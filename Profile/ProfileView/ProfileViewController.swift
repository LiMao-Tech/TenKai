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

private let InitialBlockPixelSize : Int = 75

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameAgeLabel: UILabel!
    
    @IBOutlet weak var pcoindistanceImageView: UIImageView!
    @IBOutlet weak var pcoindistanceLabel: UILabel!
    
    @IBOutlet weak var locationImageView: UIImageView!
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var quoteLabel: UILabel!
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    var userID: Int!
    var imagesJSON : [AnyObject]?
    
    let gradientMask = CAGradientLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // add Image Button
        let addImageBtn = UIBarButtonItem(title: "相簿", style: .Plain, target: self, action: "pushPictureCollectionView")
        self.navigationItem.rightBarButtonItem = addImageBtn;
        
        // Get Image JSON
        let targetUrl = ImagesJSONUrl + String(self.userID)
        ALAMO_MANAGER.request(.GET, targetUrl, encoding: .JSON) .responseJSON { response in
            
            if let values = response.result.value {
                
                self.imagesJSON = (values as? [AnyObject])!
                
                
                for obj in self.imagesJSON! {
                    let imageJSON = JSON(obj as! [String: AnyObject])
                    let imageType = imageJSON["ImageType"].intValue
                    if imageType == 0 {
                        let imageIndex = imageJSON["ID"].stringValue
                        let targetUrl = ImageUrl + imageIndex
                        ALAMO_MANAGER.request(.GET, targetUrl)
                            .responseImage { response in
                                debugPrint(response)
                                
                                if let image = response.result.value {
                                    self.profileImageView.image = image
                                }
                        }
                    }
                }
            }
        }
        
        self.title = ProfileTitle
        
        self.view.backgroundColor = UIColor.blackColor()
        
        // gradient mask
        gradientMask.frame = self.view.bounds
        gradientMask.colors = [UIColor.blackColor().CGColor, UIColor.clearColor().CGColor]
        profileImageView.layer.mask = gradientMask;
    }
    
    override func viewWillAppear(animated: Bool) {
        // update profile picture everytime
        
        
        
    }
    
    func pushPictureCollectionView() {
        // virtual
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}