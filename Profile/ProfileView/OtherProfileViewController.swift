//
//  OtherProfileViewController.swift
//  Ten
//
//  Created by Yumen Cao on 1/4/16.
//  Copyright © 2016 LiMao Tech. All rights reserved.
//

import UIKit
import CoreLocation

class OtherProfileViewController: ProfileViewController {
    
    var outerBar: TenSlider!
    var outerValue: UILabel!
    
//    var tenUser: TenUser!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // set user info
        nameLabel.text = tenUser.UserName
        quoteLabel.text = tenUser.Quote
        ageLabel.text = String(TenTimeManager.SharedInstance.getAge(NSDate(timeIntervalSince1970: tenUser.Birthday)))
        
        self.pcoindistanceImageView.image = UIImage(named: "icon_profile_distance")
        self.pcoindistanceLabel.text = ""
        
        outerBar = TenSlider(frame: CGRectMake(SCREEN_WIDTH/5, SCREEN_HEIGHT*11/12, SCREEN_WIDTH/2, SCREEN_HEIGHT/12))
        
        outerBar.minimumValue = MinBarValue
        outerBar.maximumValue = MaxBarValue
        
        outerBar.addTarget(self, action: "outerBarChanged", forControlEvents: UIControlEvents.ValueChanged)
        
        outerValue = UILabel(frame: CGRectMake(SCREEN_WIDTH*4/5, SCREEN_HEIGHT*11/12, SCREEN_WIDTH/2, SCREEN_HEIGHT/12))
        outerValue.text = String(tenUser.OuterScore)
        outerValue.textColor = UIColor.whiteColor()

        // get location
        let loc = CLLocation(latitude: tenUser.Lati, longitude: tenUser.Longi)
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

        // set distance
        if let distDouble = LOC_MANAGER.location?.distanceFromLocation(loc) {
            if distDouble > 1000 {
                let dist = String(Int(distDouble/1000))
                self.pcoindistanceLabel.text = "\(dist) kM"
            }
            else {
                let dist = String(Int(distDouble))
                self.pcoindistanceLabel.text = "\(dist) m"
            }
        }
        else {
            self.pcoindistanceLabel.text = "??"
        }


        self.view.addSubview(outerBar)
        self.view.addSubview(outerValue)

        // level colors
        var avg = (tenUser.OuterScore + tenUser.InnerScore)/2
        if avg == 0 {
            avg = 1
        }
        self.levelCircleImageView.image = UIImage(named: "icon_profile_circle_l\(avg)")
        self.levelBarImageView.backgroundColor = LEVEL_COLORS[avg-1]
        self.scoreLabel.text = "内在: \(tenUser.InnerScore)   外在: \(tenUser.OuterScore)   能量： \(tenUser.Energy)"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func outerBarChanged(){
        outerValue.text = "\(Int(outerBar.value))"
    }
}
