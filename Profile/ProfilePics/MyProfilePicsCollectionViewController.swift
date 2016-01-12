//
//  MyProfilePicsCollectionViewController.swift
//  Ten
//
//  Created by Yumen Cao on 1/6/16.
//  Copyright © 2016 LiMao Tech. All rights reserved.
//

import UIKit

class MyProfilePicsCollectionViewController: ProfilePicsCollectionViewController,
                                            UINavigationControllerDelegate,
                                            UIImagePickerControllerDelegate
{
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SHARED_PICKER.picker.delegate = self
        
        self.addToolBar()

        // add Image Button
        let addImageBtn = UIBarButtonItem(title: "新增", style: .Plain, target: self, action: "addImage")
        self.navigationItem.rightBarButtonItem = addImageBtn;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    func addImage() -> Void {
        
        SHARED_PICKER.toImagePicker(self)
    
    }
    
    func toolBarOption() -> Void {
    
    }
    
    func toolBarUnlock() -> Void {
    
    }
    
    func toolBarLock() -> Void {
    
    }
    
    func toolBarDelete() -> Void {
    
    }
    
    func addToolBar() -> Void {
        // create toolbar
        let toolBar = UIToolbar(frame: CGRectMake(0, SCREEN_HEIGHT-NAV_BAR_HEIGHT-TOOL_BAR_HEIGHT, SCREEN_WIDTH, TOOL_BAR_HEIGHT))
        toolBar.backgroundColor = UIColor.darkGrayColor()
        
        // buttons
        let optionItem = UIBarButtonItem(image: UIImage(named: "btn_tabBarIcon_option"), style: .Plain, target: self, action: "toolBarOption")
        let unlockItem = UIBarButtonItem(image: UIImage(named: "btn_tabBarIcon_unlock"), style: .Plain, target: self, action: "toolBarUnlock")
        let lockItem = UIBarButtonItem(image: UIImage(named: "btn_tabBarIcon_lock"), style: .Plain, target: self, action: "toolBarLock")
        let deleteItem = UIBarButtonItem(image: UIImage(named: "btn_tabBarIcon_delete"), style: .Plain, target: self, action: "toolBarDelete")
        
        // adjust insets
        let insets = UIEdgeInsetsMake(3, 0, 3, 0);
        optionItem.imageInsets = insets;
        optionItem.width = 15;
        unlockItem.imageInsets = insets;
        unlockItem.width = 5;
        lockItem.imageInsets = insets;
        lockItem.width = 5;
        deleteItem.imageInsets = insets;
        deleteItem.width = 5;
        
        // insert paddings between items
        let padding = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: self, action: nil)
        padding.width = (SCREEN_WIDTH - 4*optionItem.width)/3;
        
        let itemArr = [optionItem, padding, unlockItem, padding, lockItem, padding, deleteItem]
        toolBar.items = itemArr
        
        self.view.addSubview(toolBar)
        print("Toolbar added")
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        

        
        picker.dismissViewControllerAnimated(true, completion: nil)
        
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage

        let path = NSIndexPath(forItem: self.NumberOfPics-1, inSection: 0)
        
        
        self.lmCollectionView.performBatchUpdates({() -> Void in
            
            let imageRepre = UIImageJPEGRepresentation(image, 0.75)
                let params : NSDictionary = ["id": self.UserID]
            
            if let imageData = imageRepre {
                
                AFNetworkTools.postUserImage(imageData, parameters: params as! [String : AnyObject], success: { (task, response) -> Void in
                    self.numbers.addObject(0)
                    self.numberWidths.addObject(1)
                    self.numberHeights.addObject(1)
                    
                    self.lmCollectionView.insertItemsAtIndexPaths([path])
                    },failure: { (task, error) -> Void in
                        print(error.localizedDescription)
                })
            }
            }
            , completion: {(done) -> Void in
                if done {
                    let cell = self.lmCollectionView.cellForItemAtIndexPath(path) as!ProfilePicsCollectionViewCell
                    
                    cell.cellImage?.image = image
                    self.NumberOfPics += 1
                }
                
        })
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
