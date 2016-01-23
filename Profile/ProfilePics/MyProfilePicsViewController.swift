//
//  MyProfilePicsCollectionViewController.swift
//  Ten
//
//  Created by Yumen Cao on 1/6/16.
//  Copyright © 2016 LiMao Tech. All rights reserved.
//

import UIKit
import SwiftyJSON

class MyProfilePicsViewController: ProfilePicsViewController,
                                    LMCollectionViewLayoutDelegate,
                                    UICollectionViewDataSource,
                                    UINavigationControllerDelegate,
                                    UIImagePickerControllerDelegate
{
    @IBOutlet weak var topSeparator: UIImageView!
    @IBOutlet weak var verticalSeparator: UIImageView!
    
    @IBOutlet weak var levelBarImageView: UIImageView!
    @IBOutlet weak var levelCircleImageVIew: UIImageView!
    
    @IBOutlet weak var lmCollectionView: UICollectionView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    
    
    
    
    @IBAction func optionBarBtn(sender: AnyObject) {
        
        
    }

    @IBAction func unlockBarBtn(sender: AnyObject) {
        self.lmCollectionView.alpha = 0.5
    }
    
    @IBAction func lockBarBtn(sender: AnyObject) {
        
    }
    
    @IBAction func deleteBarBtn(sender: AnyObject) {
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // data initialization
        let targetUrl = ImagesJSONUrl + String(SHARED_USER.UserIndex)
        ALAMO_MANAGER.request(.GET, targetUrl) .responseJSON { response in
            if let values = response.result.value {
                self.imagesJSON = (values as? [AnyObject])!
                self.dataInit()
                self.lmCollectionView.reloadData()
            }
        }
        
        // register nib
        let cellNib = UINib(nibName: ProfilePicCellNibName, bundle: nil)
        lmCollectionView.registerNib(cellNib, forCellWithReuseIdentifier: ProfilePicCellIdentifier)
        
        // set delegates
        self.setUpCollectionView(lmCollectionView)
        lmCollectionView.delegate = self
        lmCollectionView.dataSource = self
        let lmLayout = lmCollectionView.collectionViewLayout as? LMCollectionViewLayout
        lmLayout?.delegate = self
        SHARED_PICKER.picker.delegate = self
        
        

        // add buttons
        let addImageBtn = UIBarButtonItem(title: "新增", style: .Plain, target: self, action: "addImage")
        self.navigationItem.rightBarButtonItem = addImageBtn;
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // collection view
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        magnifyCellAtIndexPath(indexPath)
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dims.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = self.lmCollectionView.dequeueReusableCellWithReuseIdentifier(self.ProfilePicCellIdentifier, forIndexPath: indexPath) as! ProfilePicCollectionViewCell
        
        let obj = self.imagesJSON[indexPath.row]
        let imageJSON = JSON(obj as! [String: AnyObject])
        let imageIndex = imageJSON["ID"].stringValue
        let targetUrl = ImageUrl + imageIndex
        ALAMO_MANAGER.request(.GET, targetUrl) .responseImage { response in
            if let image = response.result.value {
                cell.imageView.image = image
            }
            else {
                cell.backgroundColor = COLOR_BG
            }
        }
        return cell
    }
    
    func collectionView(collectionView: UICollectionView!, layout collectionViewLayout: UICollectionViewLayout!, blockSizeForItemAtIndexPath indexPath: NSIndexPath!) -> CGSize {
        let dim = self.dims[indexPath.row].rawValue
        return CGSizeMake(dim, dim)
    }
    
    func collectionView(collectionView: UICollectionView!, layout collectionViewLayout: UICollectionViewLayout!, insetsForItemAtIndexPath indexPath: NSIndexPath!) -> UIEdgeInsets {
        return UIEdgeInsetsMake(1,1,1,1)
    }
    
    func insertAtIndexPath(indexPath: NSIndexPath) {
        if indexPath.row > self.dims.count || self.isProcessing {
            return
        }
        self.isProcessing = true
        
        self.lmCollectionView.performBatchUpdates({() in
            self.numOfPics += 1
            self.dims.insert(BlockDim.Std, atIndex: indexPath.row)
            
            },
            completion: {(done) in
                self.isProcessing = false
        })
    }
    
    func magnifyCellAtIndexPath(indexPath: NSIndexPath) {
        if indexPath.row > self.dims.count || self.isProcessing {
            return
        }
        
        self.isProcessing = true
        
        let selectedCell = lmCollectionView.cellForItemAtIndexPath(indexPath) as? ProfilePicCollectionViewCell
        let cellImage = selectedCell?.imageView.image
        
        self.lmCollectionView.performBatchUpdates({() in
            self.dims.removeAtIndex(indexPath.row)
            self.lmCollectionView?.deleteItemsAtIndexPaths([indexPath])
            
            self.dims.insert(BlockDim.L, atIndex: indexPath.row)
            self.lmCollectionView?.insertItemsAtIndexPaths([indexPath])
            },
            completion: {(done) in
                let novaCell = self.lmCollectionView.cellForItemAtIndexPath(indexPath) as? ProfilePicCollectionViewCell
                novaCell?.imageView.image = cellImage
                self.isProcessing = false
        })
        
    }
    
    // image picker
    
    func addImage() -> Void {
        SHARED_PICKER.toImagePicker(self)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
    
        picker.dismissViewControllerAnimated(true, completion: nil)
        
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        // insert in the beginning
        let path = NSIndexPath(forItem: 0, inSection: 0)
        
        self.lmCollectionView.performBatchUpdates({() -> Void in
            
            let imageRepre = UIImageJPEGRepresentation(image, 0.75)
                let params : NSDictionary = ["id": SHARED_USER.UserIndex]
            
            if let imageData = imageRepre {
                
                AFNetworkTools.postUserImage(imageData, parameters: params as! [String : AnyObject], success: {(task, response) -> Void in
                    self.dims.insert(BlockDim.Std, atIndex: 0)
                    
                    self.lmCollectionView.insertItemsAtIndexPaths([path])
                    },failure: { (task, error) -> Void in
                        print(error.localizedDescription)
                })
            }
            }
            , completion: {(done) -> Void in
                if done {
                    let cell = self.lmCollectionView.cellForItemAtIndexPath(path) as! ProfilePicCollectionViewCell
                    
                    cell.imageView.image = image
                    self.numOfPics += 1
                }
        })
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
