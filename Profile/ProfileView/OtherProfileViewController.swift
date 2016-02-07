//
//  OtherProfileViewController.swift
//  Ten
//
//  Created by Yumen Cao on 1/4/16.
//  Copyright © 2016 LiMao Tech. All rights reserved.
//

import UIKit
import SwiftyJSON
import CoreLocation

class OtherProfileViewController: ProfileViewController {
    
    var outerBar: GTSlider!
    var outerValue: UILabel!
    
    var tenUserJSON: JSON!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set user info
        nameLabel.text = tenUserJSON["UserName"].stringValue
        quoteLabel.text = tenUserJSON["Quote"].stringValue
        ageLabel.text = String(TenTimeManager.SharedInstance.getAge(NSDate(timeIntervalSince1970: tenUserJSON["Birthday"].doubleValue)))
        
        self.pcoindistanceImageView.image = UIImage(named: "icon_profile_distance")
        self.pcoindistanceLabel.text = "1, 999 kM"
        
        outerBar = GTSlider(frame: CGRectMake(SCREEN_WIDTH/5, SCREEN_HEIGHT*11/12, SCREEN_WIDTH/2, SCREEN_HEIGHT/12))
        
        outerBar.minimumValue = MinBarValue
        outerBar.maximumValue = MaxBarValue
        
        outerBar.addTarget(self, action: "outerBarChanged", forControlEvents: UIControlEvents.ValueChanged)
        
        outerValue = UILabel(frame: CGRectMake(SCREEN_WIDTH*4/5, SCREEN_HEIGHT*11/12, SCREEN_WIDTH/2, SCREEN_HEIGHT/12))
        outerValue.text = tenUserJSON["OuterScore"].stringValue
        outerValue.textColor = UIColor.whiteColor()

        // get location
        let loc = CLLocation(latitude: tenUserJSON["Lati"].doubleValue, longitude: tenUserJSON["Longi"].doubleValue)
        GEO_DECODER.reverseGeocodeLocation(loc) {
            (placemarks, error) -> Void in
            if placemarks != nil {
                var locText = ""
                if let countryStr = placemarks![0].addressDictionary!["Country"] {
                    locText += String(countryStr)
                }
                if let cityStr = placemarks![0].addressDictionary!["City"] {
                    locText += " "
                    locText += String(cityStr)
                }

                if locText == "" {
                    self.locationLabel.text = "未知"
                }
                else {
                    self.locationLabel.text = locText
                }
            }
            else {
                self.locationLabel.text = "未知"
            }
        }

        self.view.addSubview(outerBar)
        self.view.addSubview(outerValue)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func pushPictureCollectionView() {
        let pPCVC = OtherProfilePicsViewController(nibName: "OtherProfilePicsViewController", bundle: nil)
        pPCVC.userID = userID
        pPCVC.tenUserJSON = tenUserJSON
        self.navigationController?.pushViewController(pPCVC, animated: true)
    }

    
    func outerBarChanged(){
        outerValue.text = "\(Int(outerBar.value))"
    }
}
