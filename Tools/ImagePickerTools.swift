//
//  ImagePicker.swift
//  Ten
//
//  Created by Yumen Cao on 1/8/16.
//  Copyright © 2016 LiMao Tech. All rights reserved.
//

import Foundation

class ImagePickerTools {
    
    // MARK: Entering the image picker
    class func toImagePicker(viewController: UIViewController, picker: UIImagePickerController) {
        
        let alert:UIAlertController = UIAlertController(title: "选择图片来源", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        let cameraAction = UIAlertAction(title: "相机", style: UIAlertActionStyle.Default)
            {
                UIAlertAction in
                openCamera(viewController, picker: picker)
        }
        let gallaryAction = UIAlertAction(title: "相册", style: UIAlertActionStyle.Default)
            {
                UIAlertAction in
                openGallary(viewController, picker: picker)
        }
        let cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel)
            {
                UIAlertAction in
                
        }
        
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
    
    class func openCamera(viewController: UIViewController, picker: UIImagePickerController) {
        
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera))
        {
            picker.sourceType = UIImagePickerControllerSourceType.Camera
            viewController.presentViewController(picker, animated: true, completion: nil)
        }
        else
        {
            openGallary(viewController, picker: picker)
        }
    }
    
    class func openGallary(viewController: UIViewController, picker: UIImagePickerController) {
        picker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        
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
