//
//  Urls.swift
//  Ten
//
//  Created by Yumen Cao on 2/12/16.
//  Copyright © 2016 LiMao Tech. All rights reserved.
//

import Foundation

let Url_Home = "http://www.limao-tech.com/Ten/"

let Url_Api = Url_Home + "api/"
let Url_Login = Url_Api + "TenLogins/"
let Url_User = Url_Api + "TenUsers/"
let Url_Msg = Url_Api + "TenMsgs/"
let Url_PCoin = Url_Api + "PCoinTrans/"
let Url_Rater = Url_Api + "Rater/"
let Url_Purchase = Url_Api + "Purchase/"


// Image related
let Url_Unlocker = Url_Api + "ImageUnlocker/"

let Url_ImageMaster = "http://www.limao-tech.com/Ten/TenImage/"

let Url_ImagesJSON = Url_ImageMaster + "GetImagesByUser?id="
let Url_Image = Url_ImageMaster + "?id="
let Url_DeletePic = Url_ImageMaster + "DeletePhoto"

let Url_GetHeadImage = Url_ImageMaster + "GetProfileByUser?userIndex="
let Url_UploadHeadImage = Url_ImageMaster + "UploadProfileImage/"
let Url_UploadPhotos = Url_ImageMaster + "UploadPhotos/"
let Url_GetAlbumImage = Url_ImageMaster + "GetAlbumImages?id=" // Returns JSON

let Url_SetImage = Url_ImageMaster + "ChangeImageType"
let Url_Lock = Url_ImageMaster + "SetIsLocked"
let Url_PutImageJSON = Url_ImageMaster + "PutTenImage"

let Url_SendImage = Url_Home+"TenImage/SendImage"



let Url_DeviceToken = ""


