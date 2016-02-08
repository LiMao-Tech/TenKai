//
//  SharedInstances.swift
//  Ten
//
//  Created by Yumen Cao on 1/8/16.
//  Copyright © 2016 LiMao Tech. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireImage
import CoreLocation



let ALAMO_MANAGER = Alamofire.Manager.sharedInstance
let LOC_MANAGER = CLLocationManager()
let GEO_DECODER = CLGeocoder()

let SHARED_APP = UIApplication.sharedApplication()
let SHARED_USER = SharedUser.SharedInstance

let SHARED_PICKER = LMImagePicker()

let SHARED_IMAGE_CACHE = AutoPurgingImageCache()