//
//  MeProfileMasterViewController.swift
//  Ten
//
//  Created by Yumen Cao on 2/27/16.
//  Copyright © 2016 LiMao Tech. All rights reserved.
//

import UIKit
import SwiftyJSON

class MeProfileMasterViewController: ProfileMasterViewController,
                                        UINavigationControllerDelegate,
                                        UIImagePickerControllerDelegate
{
    let pVC = MyProfileViewController(nibName: "ProfileViewController", bundle: nil)
    let pPCVC = MyProfilePicsViewController(nibName: "MyProfilePicsViewController", bundle: nil)

    let uploadController = UIAlertController(title: "上传中", message: "请稍后。", preferredStyle: .Alert)

    override func viewDidLoad() {
        super.viewDidLoad()

        // navigation
        let addImageBtn = UIBarButtonItem(title: "新增", style: .Plain, target: self, action: "addImage")
        self.navigationItem.rightBarButtonItem = addImageBtn


        let activeFrameHeight = SCREEN_HEIGHT-STATUSBAR_HEIGHT-(self.navigationController?.navigationBar.frame.height)!

        // child controller
        pVC.view.frame = CGRectMake(0, 0, profileSV.frame.width, profileSV.frame.height)
        pPCVC.view.frame = CGRectMake(0, activeFrameHeight, profileSV.frame.width, profileSV.frame.height)
        pPCVC.pVC = pVC

        addChildViewController(pVC)
        addChildViewController(pPCVC)
        
        profileSV.addSubview(pVC.view)
        profileSV.addSubview(pPCVC.view)


        // images
        SHARED_PICKER.picker.delegate = self
        getImagesJSON()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()


    }

    // image picker

    func addImage() -> Void {
        SHARED_PICKER.toImagePicker(self)
    }

    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {

        picker.dismissViewControllerAnimated(true, completion: nil)

        let image = info[UIImagePickerControllerOriginalImage] as! UIImage

        let imageRepre = UIImageJPEGRepresentation(image, 0.75)
        let params: [String: AnyObject] = ["id": SHARED_USER.UserIndex]

        if let imageData = imageRepre {
            presentViewController(uploadController, animated: true, completion: nil)
            AFImageManager.SharedInstance.postUserImage(imageData, parameters: params, success: {(task, response) -> Void in
                TenImagesJSONManager.SharedInstance.getJSONUpdating(self, alert: self.uploadController)

                },failure: { (task, error) -> Void in
                    print(error.localizedDescription)
            })
        }
    }


    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
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
                        if self.pVC.numProfilePics < 2 {
                         self.pVC.numProfilePics = 2
                        }
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
}
