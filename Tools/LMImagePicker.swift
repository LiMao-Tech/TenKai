//
//  ImagePicker.swift
//  Ten
//
//  Created by Yumen Cao on 1/8/16.
//  Copyright © 2016 LiMao Tech. All rights reserved.
//

import Foundation

class LMImagePicker: NSObject {
    
    let picker = UIImagePickerController()
    
    // MARK: Entering the image picker
    func toImagePicker(viewController: UIViewController) {
        
        let alert:UIAlertController = UIAlertController(title: "选择图片来源", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        let cameraAction = UIAlertAction(title: "相机", style: UIAlertActionStyle.Default)
        {
                UIAlertAction in
                self.openCamera(viewController)
        }
        let gallaryAction = UIAlertAction(title: "相册", style: UIAlertActionStyle.Default)
        {
                UIAlertAction in
                self.openGallary(viewController)
        }
        let cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: nil)
        
        alert.addAction(cameraAction)
        alert.addAction(gallaryAction)
        alert.addAction(cancelAction)
        
        // Present the controller
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone
        {
            viewController.presentViewController(alert, animated: true, completion: nil)
        }
        else
        {
            print("Please use an IPhone for this action")
        }
    }
    
    private func openCamera(viewController: UIViewController) {
        
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera))
        {
            self.picker.sourceType = UIImagePickerControllerSourceType.Camera
            viewController.presentViewController(picker, animated: true, completion: nil)
        }
        else
        {
            self.openGallary(viewController)
        }
    }
    
    private func openGallary(viewController: UIViewController) {
        self.picker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone
        {
            viewController.presentViewController(picker, animated: true, completion: nil)
        }
        else
        {
            print("Please use an IPhone for this action")
        }
    }
}
